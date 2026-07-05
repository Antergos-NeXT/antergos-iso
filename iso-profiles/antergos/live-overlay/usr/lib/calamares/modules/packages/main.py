#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# === This file is part of Calamares - <https://calamares.io> ===
#
#   SPDX-FileCopyrightText: 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#   SPDX-FileCopyrightText: 2015-2017 Teo Mrnjavac <teo@kde.org>
#   SPDX-FileCopyrightText: 2016-2017 Kyle Robbertze <kyle@aims.ac.za>
#   SPDX-FileCopyrightText: 2017 Alf Gaida <agaida@siduction.org>
#   SPDX-FileCopyrightText: 2018 Adriaan de Groot <groot@kde.org>
#   SPDX-FileCopyrightText: 2018 Philip Müller <philm@manjaro.org>
#   SPDX-License-Identifier: GPL-3.0-or-later
#
#   Calamares is Free Software: see the License-Identifier above.
#
#   Antergos NeXT: Install one-at-a-time with error isolation,
#   --overwrite='*' to avoid file conflicts, and per-package logging.

import abc
from string import Template
import subprocess

import libcalamares
from libcalamares.utils import check_target_env_call, target_env_call
from libcalamares.utils import gettext_path, gettext_languages

import gettext
_translation = gettext.translation("calamares-python",
                                   localedir=gettext_path(),
                                   languages=gettext_languages(),
                                   fallback=True)
_ = _translation.gettext
_n = _translation.ngettext


total_packages = 0
completed_packages = 0
group_packages = 0

custom_status_message = None

INSTALL = object()
REMOVE = object()
mode_packages = None


def _change_mode(mode):
    global mode_packages
    mode_packages = mode
    libcalamares.job.setprogress(completed_packages * 1.0 / total_packages)


def pretty_name():
    return _("Install packages.")


def pretty_status_message():
    if custom_status_message is not None:
        return custom_status_message
    if not group_packages:
        if (total_packages > 0):
            s = _("Processing packages (%(count)d / %(total)d)")
        else:
            s = _("Install packages.")
    elif mode_packages is INSTALL:
        s = _n("Installing one package.",
               "Installing %(num)d packages.", group_packages)
    elif mode_packages is REMOVE:
        s = _n("Removing one package.",
               "Removing %(num)d packages.", group_packages)
    else:
        s = _("Install packages.")
    return s % {"num": group_packages,
                "count": completed_packages,
                "total": total_packages}


class PackageManager(metaclass=abc.ABCMeta):
    backend = None

    @abc.abstractmethod
    def install(self, pkgs, from_local=False):
        pass

    @abc.abstractmethod
    def remove(self, pkgs):
        pass

    @abc.abstractmethod
    def update_db(self):
        pass

    def run(self, script):
        if script != "":
            check_target_env_call(script.split(" "))

    def install_package(self, packagedata, from_local=False):
        if isinstance(packagedata, str):
            self.install([packagedata], from_local=from_local)
        else:
            self.run(packagedata["pre-script"])
            self.install([packagedata["package"]], from_local=from_local)
            self.run(packagedata["post-script"])

    def remove_package(self, packagedata):
        if isinstance(packagedata, str):
            self.remove([packagedata])
        else:
            self.run(packagedata["pre-script"])
            self.remove([packagedata["package"]])
            self.run(packagedata["post-script"])

    def operation_install(self, package_list, from_local=False):
        if all([isinstance(x, str) for x in package_list]):
            self.install(package_list, from_local=from_local)
        else:
            for package in package_list:
                self.install_package(package, from_local=from_local)

    def operation_try_install(self, package_list):
        for package in package_list:
            try:
                self.install_package(package)
            except subprocess.CalledProcessError:
                libcalamares.utils.warning("Could not install package %s" % package)

    def operation_remove(self, package_list):
        if all([isinstance(x, str) for x in package_list]):
            self.remove(package_list)
        else:
            for package in package_list:
                self.remove_package(package)

    def operation_try_remove(self, package_list):
        for package in package_list:
            try:
                self.remove_package(package)
            except subprocess.CalledProcessError:
                libcalamares.utils.warning("Could not remove package %s" % package)


class PMDummy(PackageManager):
    backend = "dummy"

    def install(self, pkgs, from_local=False):
        from time import sleep
        libcalamares.utils.debug("Dummy backend: Installing " + str(pkgs))
        sleep(3)

    def remove(self, pkgs):
        from time import sleep
        libcalamares.utils.debug("Dummy backend: Removing " + str(pkgs))
        sleep(3)

    def update_db(self):
        libcalamares.utils.debug("Dummy backend: Updating DB")

    def update_system(self):
        libcalamares.utils.debug("Dummy backend: Updating System")

    def run(self, script):
        libcalamares.utils.debug("Dummy backend: Running script '" + str(script) + "'")


class PMPacman(PackageManager):
    backend = "pacman"

    def __init__(self):
        import re
        progress_match = re.compile("^\\((\\d+)/(\\d+)\\)")

        def line_cb(line):
            if line.startswith(":: "):
                self.in_package_changes = "package" in line or "hooks" in line
            else:
                if self.in_package_changes and line.endswith("...\n"):
                    global custom_status_message
                    custom_status_message = "pacman: " + line.strip()
                    libcalamares.job.setprogress(self.progress_fraction)
            libcalamares.utils.debug(line)

        self.in_package_changes = False
        self.line_cb = line_cb

        pacman = libcalamares.job.configuration.get("pacman", None)
        if pacman is None:
            pacman = dict()
        if type(pacman) is not dict:
            libcalamares.utils.warning("Job configuration *pacman* will be ignored.")
            pacman = dict()
        self.pacman_num_retries = pacman.get("num_retries", 0)
        self.pacman_disable_timeout = pacman.get("disable_download_timeout", False)
        self.pacman_needed_only = pacman.get("needed_only", False)

    def reset_progress(self):
        self.in_package_changes = False
        self.progress_fraction = (completed_packages * 1.0 / total_packages)

    def run_pacman(self, command, callback=False):
        pacman_count = 0
        while pacman_count <= self.pacman_num_retries:
            pacman_count += 1
            try:
                libcalamares.utils.target_env_process_output(command)
                return
            except subprocess.CalledProcessError:
                if pacman_count <= self.pacman_num_retries:
                    pass
                else:
                    raise

    def install(self, pkgs, from_local=False):
        for pkg in pkgs:
            command = ["pacman"]
            if from_local:
                command.append("-U")
            else:
                command.append("-S")

            command.append("--noconfirm")
            command.append("--noprogressbar")
            command.append("--overwrite=*")

            # Pre-tend init-logind is already provided so pacman's resolver
            # skips provider selection entirely, preventing it from selecting
            # elogind-dinit (alphabetically before elogind-openrc) which would
            # pull in dinit -> dinit-rc and conflict with OpenRC.
            if libcalamares.globalstorage.contains("initProvider"):
                provider = libcalamares.globalstorage.value("initProvider")
                if provider and provider != "dinit":
                    command.append("--assume-installed=init-logind")

            # Safety net: auto-answer YES to conflict resolution
            command.append("--ask=4")

            if self.pacman_needed_only is True:
                command.append("--needed")
            if self.pacman_disable_timeout is True:
                command.append("--disable-download-timeout")

            command.append(pkg)

            self.reset_progress()
            try:
                self.run_pacman(command, True)
                libcalamares.utils.debug("package_ok: {!s}".format(pkg))
            except subprocess.CalledProcessError as e:
                libcalamares.utils.warning("package_fail: {!s}".format(pkg))
                libcalamares.utils.debug("stdout:" + str(e.stdout))
                libcalamares.utils.debug("stderr:" + str(e.stderr))
                raise

    def remove(self, pkgs):
        self.reset_progress()
        self.run_pacman(["pacman", "-Rs", "--noconfirm"] + pkgs, True)

    def update_db(self):
        self.run_pacman(["pacman", "-Sy"])

    def update_system(self):
        command = ["pacman", "-Su", "--noconfirm"]
        if self.pacman_disable_timeout is True:
            command.append("--disable-download-timeout")

        self.run_pacman(command)


backend_managers = [
    (c.backend, c)
    for c in globals().values()
    if type(c) is abc.ABCMeta and issubclass(c, PackageManager) and c.backend]


def subst_locale(plist):
    locale = libcalamares.globalstorage.value("locale")
    if not locale:
        locale = "en"

    ret = []
    for packagedata in plist:
        if isinstance(packagedata, str):
            packagename = packagedata
        else:
            packagename = packagedata["package"]

        if locale != "en":
            packagename = Template(packagename).safe_substitute(LOCALE=locale)
        elif 'LOCALE' in packagename:
            packagename = None

        if packagename is not None:
            if isinstance(packagedata, str):
                packagedata = packagename
            else:
                packagedata["package"] = packagename
            ret.append(packagedata)

    return ret


def run_operations(pkgman, entry):
    global group_packages, completed_packages, mode_packages

    for key in entry.keys():
        package_list = subst_locale(entry[key])
        group_packages = len(package_list)
        if key == "install":
            _change_mode(INSTALL)
            pkgman.operation_install(package_list)
        elif key == "try_install":
            _change_mode(INSTALL)
            pkgman.operation_try_install(package_list)
        elif key == "remove":
            _change_mode(REMOVE)
            pkgman.operation_remove(package_list)
        elif key == "try_remove":
            _change_mode(REMOVE)
            pkgman.operation_try_remove(package_list)
        elif key == "localInstall":
            _change_mode(INSTALL)
            pkgman.operation_install(package_list, from_local=True)
        elif key == "source":
            libcalamares.utils.debug("Package-list from {!s}".format(entry[key]))
        else:
            libcalamares.utils.warning("Unknown package-operation key {!s}".format(key))
        completed_packages += len(package_list)
        libcalamares.job.setprogress(completed_packages * 1.0 / total_packages)
        libcalamares.utils.debug("Pretty name: {!s}, setting progress..".format(pretty_name()))

    group_packages = 0
    _change_mode(None)


def run():
    global mode_packages, total_packages, completed_packages, group_packages

    backend = libcalamares.job.configuration.get("backend")

    for identifier, impl in backend_managers:
        if identifier == backend:
            pkgman = impl()
            break
    else:
        return "Bad backend", "backend=\"{}\"".format(backend)

    skip_this = libcalamares.job.configuration.get("skip_if_no_internet", False)
    if skip_this and not libcalamares.globalstorage.value("hasInternet"):
        libcalamares.utils.warning("Package installation has been skipped: no internet")
        return None

    update_db = libcalamares.job.configuration.get("update_db", False)
    if update_db and libcalamares.globalstorage.value("hasInternet"):
        try:
            pkgman.update_db()
        except subprocess.CalledProcessError as e:
            libcalamares.utils.warning(str(e))
            libcalamares.utils.debug("stdout:" + str(e.stdout))
            libcalamares.utils.debug("stderr:" + str(e.stderr))
            libcalamares.utils.warning("Continuing despite update_db failure")

    operations = libcalamares.job.configuration.get("operations", [])
    if libcalamares.globalstorage.contains("packageOperations"):
        operations += libcalamares.globalstorage.value("packageOperations")

    mode_packages = None
    total_packages = 0
    completed_packages = 0
    for op in operations:
        for packagelist in op.values():
            total_packages += len(subst_locale(packagelist))

    if not total_packages:
        return None

    errors = []
    for entry in operations:
        group_packages = 0
        libcalamares.utils.debug(pretty_name())
        try:
            run_operations(pkgman, entry)
        except subprocess.CalledProcessError as e:
            libcalamares.utils.warning(str(e))
            libcalamares.utils.debug("stdout:" + str(e.stdout))
            libcalamares.utils.debug("stderr:" + str(e.stderr))
            errors.append((e.cmd, e.returncode, e.stderr))
            libcalamares.utils.debug("Continuing despite package error")

    mode_packages = None
    libcalamares.job.setprogress(1.0)

    if errors:
        return (None,
                "Package installation completed with {!s} errors. "
                "Check the logs for details.".format(len(errors)))

    return None
