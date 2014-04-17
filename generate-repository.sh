#!/bin/bash

export BASE_PATH="binaries/"
export PROVIDE_ONLY=true
export REPOSITORY="/srv/repository"
export REPOS="saucy"
export SKIP_REMOVAL=true

/usr/bin/generate-reprepro-codename "${REPOS}"
/usr/bin/build-and-provide-package
