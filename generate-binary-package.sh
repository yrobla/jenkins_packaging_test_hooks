#!/bin/bash
# Purpose: prepare setup and invoke Debian binary package build

# configuration for build-and-provide-package and its tools
export DEB_BUILD_OPTIONS="parallel=$(nproc)"
export BUILD_ONLY=true
export SUDO_CMD=sudo
export COWBUILDER_DIST=unstable
export distribution=unstable
export POST_BUILD_HOOK=/home/ubuntu/jenkins_packaging_test/generate-debc.sh

# execute main jenkins-debian-glue script
/usr/bin/build-and-provide-package
