#!/usr/bin/env python3


import argparse
from pathlib import Path
import platform
import logging
from typing import Optional
from contextlib import contextmanager
import subprocess as sp
import os
import shutil


logging.basicConfig(
    level=logging.WARNING, format="[%(asctime)s] %(levelname)7s:%(message)s"
)
logger = logging.getLogger("deploy")


class Deployer(object):
    @classmethod
    def deploy(cls) -> None:
        parser = argparse.ArgumentParser()
        parser.add_argument("-n", "--dry-run", action="store_true", default=False)
        parser.add_argument(
            "-H",
            "--homebrew",
            action="store_true",
            default=False,
            help="Install homebrew bundles (if on macos)",
        )
        parser.add_argument("-f", "--force", action="store_true", default=False)
        parser.add_argument(
            "-c",
            "--compile",
            action="store_true",
            default=False,
            help="Compile packages under `external`",
        )
        parser.add_argument(
            "-r",
            "--root",
            required=False,
            default=Path.home(),
            type=Path,
            help="Install to a different root directory [default = home]",
        )
        parser.add_argument("-v", "--verbose", action="count")
        args = parser.parse_args()

        if args.verbose is not None:
            if args.verbose == 1:
                logger.setLevel(logging.INFO)
            elif args.verbose > 1:
                logger.setLevel(logging.DEBUG)

        logger.info("deploying dotfiles")
        logger.debug("debug logging enabled")

        self = cls(args)
        self.run()

    def __init__(self, args) -> None:
        self.args = args

    @property
    def dry_run(self):
        return self.args.dry_run

    @property
    def force(self):
        return self.args.force

    @property
    def compile(self):
        return self.args.compile

    @property
    def root(self):
        return self.args.root

    @property
    def homebrew(self):
        return self.args.homebrew

    def run(self) -> None:
        self.deploy_standard_dirs()
        self.deploy_dotconfig_files()
        if self.macos():
            self.deploy_kitty_config()
            if not self.homebrew:
                logger.warning(
                    "not installing homebrew packages as `-H/--homebrew` not specified"
                )
            else:
                homebrew = Homebrew()
                homebrew.install()
                homebrew.install_packages()

        if self.compile:
            self.install_rust_packages()
            self.install_custom_binaries()
        else:
            logger.warning(
                "`-c/--compile` not supplied, not compiling packages under `external`"
            )

    def deploy_standard_dirs(self, install_path: Optional[Path] = None) -> None:
        dirnames = [
            "vim",
            "zsh",
            "tmux",
            "bin",
            "conda",
            "emacs",
            "fish",
            "git",
            "hammerspoon",
            "i3",
            "ipython",
            "jupyter",
            "mutt",
            "pgcli",
            "postgresql",
            "xinitrc",
            "xresources",
            "xmodmap",
        ]
        for dirname in dirnames:
            src = Path.cwd().joinpath(dirname).resolve()
            self.deploy_standard_dir(src, install_path=install_path)

    def deploy_standard_dir(
        self, dirname: Path, install_path: Optional[Path] = None
    ) -> None:
        if install_path is None:
            install_path = self.root.resolve()

        logger.info("deploying %s", dirname)
        source = Path.cwd().resolve().joinpath(dirname)
        for src in source.glob("*"):
            dst = install_path.joinpath(f".{src.name}")
            logger.debug("- deploying %s to %s", src, dst)

            if dst.exists() and not self.force:
                logger.debug("--> path exists, skipping")
                continue

            dst.symlink_to(src)
            logger.debug("--> linking complete")

    def deploy_dotconfig_files(self):
        for subdir in [
            "direnv",
            "alacritty",
            "bspwm",
            "polybar",
            "sxhkd",
            "rofi",
            "picom",
            "nvim",
            "bat",
            "karabiner",
        ]:
            self.deploy_dotconfig_file(subdir)

    def deploy_dotconfig_file(self, subdir):
        srcs = Path.cwd().joinpath(subdir).glob("*")
        for src in srcs:
            dest = self.root.resolve().joinpath(".config", subdir, src.name)
            self._deploy_single_file(src, dest)

    def deploy_kitty_config(self):
        srcs = (Path.cwd() / "kitty" / "kitty").glob("*")
        dest_dir = self.root / "Library" / "Preferences" / "kitty"
        for src in srcs:
            logger.info("deploying %s", src)
            dest = dest_dir / src.name
            if dest.exists() and not self.force:
                logger.debug("--> path exists, skipping")
                continue

            try:
                dest.symlink_to(src)
            except FileExistsError:
                try:
                    shutil.rmtree(dest)
                except NotADirectoryError:
                    os.remove(dest)
                dest.symlink_to(src)
            logger.debug("--> linking complete")

    def install_rust_packages(self):
        if not self._binary_exists("cargo"):
            logger.warning(
                "cannot find rust installation, skipping installing rust binaries"
            )
            return

        subdirs = ["external/git-identity-manager", "external/mkflashdriverepo"]
        for subdir in subdirs:
            if not os.path.isdir(subdir):
                continue
            cmd = ["cargo", "install", "--path", subdir]
            sp.run(cmd)

    def install_custom_binaries(self):
        if not self._binary_exists("go"):
            logger.warning("cannot find go compiler, skipping installing git-bug")
            return

        # git-bug
        logger.debug("compiling and installing external/git-bug")
        cmd = ["make", "-C", str(Path.cwd() / "external" / "git-bug"), "install"]
        sp.run(cmd)

        # gomodinit
        logger.debug("compiling and installing external/gomodinit")
        with self._chdir("external/gomodinit"):
            cmd = ["go", "install"]
            sp.run(cmd)

    def _deploy_single_file(self, src, dest):
        dest.parent.mkdir(parents=True, exist_ok=True)

        logger.info("deploying %s -> %s", src, dest)

        if dest.exists() and not self.force:
            logger.debug("--> path exists, skipping")
            return

        dest.symlink_to(src)
        logger.debug("--> linking complete")

    def _binary_exists(self, name):
        pathvar = os.environ["PATH"]
        for component in pathvar.split(":"):
            if not component:
                continue
            loc = Path(component)
            if not loc.is_dir():
                continue

            if loc / name:
                return True

        return False

    @contextmanager
    def _chdir(self, path):
        oldpath = os.getcwd()
        try:
            os.chdir(path)
            yield
        finally:
            os.chdir(oldpath)

    def macos(self):
        return platform.system() == "Darwin"


class Homebrew(object):
    def install(self):
        # TODO install homebrew itself. Note: this requires user interaction to disable SIP etc.
        pass

    def install_packages(self):
        # Check that we have a Brewfile in the current directory
        if not (Path.cwd() / "Brewfile").is_file():
            raise RuntimeError("cannot find brewfile in current directory")

        # Run the command
        cmd = ["brew", "bundle"]
        logger.info("deploying homebrew packages")
        logger.debug("running command: %s", cmd)
        sp.run(cmd)


if __name__ == "__main__":
    Deployer.deploy()
