#!/bin/bash

# REQUIRED
export PACKAGE_NAME="openssl"
export PACKAGE_VERSION="1.0.0k"

# OPTIONAL
export INSTALL_PATH="${HOME}/${PACKAGE_NAME}-${PACKAGE_VERSION}"
export MAKE_SYMLINK="true"
export NEED_MAKE_TEST="true"
export NEED_MAKE_DEPEND="false"

export CONFIGURE_COMMAND="./config"
export CONFIGURE_OPTION="-fPIC"
