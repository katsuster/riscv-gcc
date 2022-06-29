#!/bin/sh

if test "x${DEBIAN}" = "x"; then
	DEBIAN=debian
fi
if test "x${DIR_SRC}" = "x"; then
	DIR_SRC=.src
fi
if test "x${PKG_TARGET}" = "x"; then
	echo "Please set PKG_TARGET"
	exit 1
fi
if test "x${SECT}" = "x"; then
	echo "Please set SECT"
	exit 1
fi
if test "x${PROJ}" = "x"; then
	echo "Please set PROJ"
	exit 1
fi
if test "x${PROJ_ORG}" = "x"; then
	PROJ_ORG=${PROJ}
fi
if test "x${VER}" = "x"; then
	echo "Please set VER"
	exit 1
fi


echo "DEBIAN    : ${DEBIAN}"
echo "DIR_SRC   : ${DIR_SRC}"
echo "PKG_TARGET: ${PKG_TARGET}"
echo "SECT      : ${SECT}"
echo "PROJ      : ${PROJ}"
echo "PROJ_ORG  : ${PROJ_ORG}"
echo "VER       : ${VER}"

set -ex

WORK=pkg_${PKG_TARGET}
ARCH=${DIR_SRC}/${PROJ_ORG}-${VER}.tar.xz

VER_GMP=6.2.1
VER_MPFR=4.1.0
VER_MPC=1.2.1
VER_ISL=0.24

# Prerequisites
curl http://gcc.gnu.org/pub/gcc/infrastructure/gmp-${VER_GMP}.tar.bz2   > gmp-${VER_GMP}.tar.bz2
curl http://gcc.gnu.org/pub/gcc/infrastructure/mpfr-${VER_MPFR}.tar.bz2 > mpfr-${VER_MPFR}.tar.bz2
curl http://gcc.gnu.org/pub/gcc/infrastructure/mpc-${VER_MPC}.tar.gz    > mpc-${VER_MPC}.tar.gz
curl http://gcc.gnu.org/pub/gcc/infrastructure/isl-${VER_ISL}.tar.bz2   > isl-${VER_ISL}.tar.bz2
./contrib/download_prerequisites

# Create original source archive
mkdir -p ${DIR_SRC}
git archive --format=tar HEAD > ${ARCH}
mkdir -p ${WORK}/${PROJ}-${VER} && cd ${WORK}/${PROJ}-${VER}
tar xf ../../${ARCH}

# Move sources to top working directory
#mv ${PROJ_ORG}-${VER}/* ./
#rmdir ${PROJ_ORG}-${VER}

# Copy debian, libs, remove CI files
cp -a ../../${DEBIAN} ./debian
cp -a ../../gmp-${VER_GMP}   ./
cp -a ../../mpfr-${VER_MPFR} ./
cp -a ../../mpc-${VER_MPC}   ./
cp -a ../../isl-${VER_ISL}   ./
ln -s gmp-${VER_GMP}   gmp
ln -s mpfr-${VER_MPFR} mpfr
ln -s mpc-${VER_MPC}   mpc
ln -s isl-${VER_ISL}   isl
rm -rf .github debian_* pkg_script

# For nightly
if [ x${SECT} = "xnightly" ]; then
	REV=`date +%Y%m%d%H%M%S`-`git rev-parse --short HEAD`;
	sed -i -e "0,/)/ s/)/-${REV})/" debian/changelog;
	PKGVER=${REV}
else
	PKGVER=${VER}-`git rev-parse --short HEAD`;
fi
echo -n "${PKGVER}" > PKGVERSION

cd ../
cp -a ${PROJ}-${VER} ${PROJ}-${VER}.orig

# Make package
export DEB_BUILD_MAINT_OPTIONS=hardening=-format
cd ${PROJ}-${VER}
debuild -uc -us
cd ../

# Clean
rm -rf ${PROJ}-${VER}
