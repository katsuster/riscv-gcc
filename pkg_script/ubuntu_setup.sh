#!/bin/sh

if test "x${PKG_TARGET}" = "x"; then
	echo "Please set PKG_TARGET"
	exit 1
fi
if test "x${URL_PACKAGE}" = "x"; then
	echo "Please set URL_PACKAGE"
	exit 1
fi

echo "PKG_TARGET  : ${PKG_TARGET}"
echo "URL_PACKAGE : ${URL_PACKAGE}"
echo "DEB_BINUTILS: ${DEB_BINUTILS}"
echo "DEB_LINUX   : ${DEB_LINUX}"
echo "DEB_NEWLIB  : ${DEB_NEWLIB}"
echo "DEB_GLIBC   : ${DEB_GLIBC}"
echo "DEB_MUSL    : ${DEB_MUSL}"

URL_BINUTILS="${URL_PACKAGE}/binutils-gdb/releases/download/riscv-binutils-${DEB_BINUTILS}"
URL_LINUX="${URL_PACKAGE}/linux-headers/releases/download/riscv-linux-headers-${DEB_LINUX}"
URL_NEWLIB="${URL_PACKAGE}/newlib-cygwin/releases/download/riscv-newlib-${DEB_NEWLIB}"
URL_GLIBC="${URL_PACKAGE}/glibc/releases/download/riscv-glibc-${DEB_GLIBC}"
URL_MUSL="${URL_PACKAGE}/musl/releases/download/riscv-musl-${DEB_MUSL}"

sudo apt-get install -y build-essential debhelper devscripts gettext \
	python3-dev curl flex bison

if test "x${DEB_BINUTILS}" = "x"; then
	curl -L ${URL_BINUTILS}/riscv64-binutils_${DEB_BINUTILS}_amd64.deb > riscv64-binutils.deb
	curl -L ${URL_BINUTILS}/riscv64-linux-glibc-binutils_${DEB_BINUTILS}_amd64.deb > riscv64-linux-glibc-binutils.deb
	curl -L ${URL_BINUTILS}/riscv64-linux-musl-binutils_${DEB_BINUTILS}_amd64.deb > riscv64-linux-musl-binutils.deb
	sudo dpkg -i riscv64-binutils.deb
	sudo dpkg -i riscv64-linux-glibc-binutils.deb
	sudo dpkg -i riscv64-linux-musl-binutils.deb
fi

if test "x${DEB_LINUX}" = "x"; then
	curl -L ${URL_LINUX}/riscv64-linux-glibc-headers_${DEB_LINUX}_amd64.deb > riscv64-linux-glibc-headers.deb
	curl -L ${URL_LINUX}/riscv64-linux-musl-headers_${DEB_LINUX}_amd64.deb > riscv64-linux-musl-headers.deb
	sudo dpkg -i riscv64-linux-glibc-headers.deb
	sudo dpkg -i riscv64-linux-musl-headers.deb
fi

if test "x${DEB_NEWLIB}" = "x"; then
	curl -L ${URL_NEWLIB}/riscv64-newlib_${DEB_NEWLIB}_amd64.deb > riscv64-newlib.deb
	sudo dpkg -i riscv64-newlib.deb
fi

if test "x${DEB_GLIBC}" != "x"; then
	curl -L ${URL_GLIBC}/riscv64-linux-glibc_${DEB_GLIBC}_amd64.deb > riscv64-linux-glibc.deb
	sudo dpkg -i riscv64-linux-glibc.deb
fi

if test "x${DEB_MUSL}" != "x"; then
	curl -L ${URL_MUSL}/riscv64-linux-musl_${DEB_MUSL}_amd64.deb > riscv64-linux-musl.deb
	sudo dpkg -i riscv64-linux-musl.deb
fi
