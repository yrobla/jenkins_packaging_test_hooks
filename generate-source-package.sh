#!/bin/bash
# Purpose: generate Debian source package based on project's git repository
# schema:
# $debian_dir: and one directory for every distribution
# $debian_auto_version: how the automatic version is created
# $tagbase: tag to use for git describe

# debug info
env

# defaults
PACKAGES_PATH=$1
PROJECT_PARTS=( ${ZUUL_PROJECT//\// } )
DEBIAN_PACKAGE=${PROJECT_PARTS[1]}

cd $WORKSPACE
rm -rf ${DEBIAN_PACKAGE}
git clone ${PACKAGES_PATH}/${DEBIAN_PACKAGE}
cd ${DEBIAN_PACKAGE}/

# get latest version to generate the tarball
ORIG_VERSION=`dpkg-parsechangelog | sed -n 's/^Version: //p'`
MAJOR_VERSION=`echo $ORIG_VERSION | sed -e 's/^[\[:digit:]]*://' -e 's/[-].*//'`

cd ../source/
tar -czvf ../${DEBIAN_PACKAGE}_${MAJOR_VERSION}.orig.tar.gz *
cd ..

# remove original files and copy debian files into branch
rm -rf source/.[^.]*
cp -R ${DEBIAN_PACKAGE}/debian source/

cd source/
rm -rf debian/patches

export DEBEMAIL="Yolanda Robla Mota <yolanda.robla-mota@hp.com>"

TIMESTAMP="$(date -u +%Y%m%d%H%M%S)"
DISTRIBUTION=$(dpkg-parsechangelog --count 1 | awk '/^Distribution/ {print $2}')
AUTO_VERSION="${ORIG_VERSION}+0~${TIMESTAMP}.${BUILD_NUMBER}"

echo "*** Building version (${AUTO_VERSION}+${distribution}).***"
dch -b --distribution="${DISTRIBUTION}" \
  --newversion="${AUTO_VERSION}+${distribution}" \
  -- "Automated package build."

dpkg-buildpackage -uc -us -nc -d -S -i -I --source-option=--unapply-patches
