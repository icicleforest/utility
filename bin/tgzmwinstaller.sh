#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}


ShowUsage()
{
    cat <<MSG
Usage:\
 PACKAGE_NAME=\${package_name}\
 PACKAGE_VERSION=\${package_version}\
 INSTALL_PATH=\${path_parent_directory}\
 $0
MSG
}



Include "../lib/stdfunc.shh"
Include "../lib/stdutil.shh"
Include "../lib/wget.shh"
Include "../lib/configure.shh"
Include "../lib/make.shh"


IsDefined DEFAULT_PROGRAM_INSTALL_PATH ||
    DEFAULT_PROGRAM_INSTALL_PATH="/usr/local"

! IsDefined PACKAGE_NAME && ShowUsage && Abort
! IsDefined PACKAGE_VERSION && ShowUsage && Abort

IsDefined MAKE_SYMLINK ||
    MAKE_SYMLINK="${FALSE}"
IsDefined INSTALL_PATH ||
    INSTALL_PATH="${DEFAULT_PROGRAM_INSTALL_PATH}/${PACKAGE_NAME}-${PACKAGE_VERSION}"
IsDefined SYMLINK_PATH ||
    SYMLINK_PATH="${INSTALL_PATH}/../${PACKAGE_NAME}"

IsDefined REPOSITORY_URL ||
    REPOSITORY_URL="http://repo.red.icicleforest.com/tgz/"
IsDefined TEMP_DIR_PATH ||
    TEMP_DIR_PATH="/tmp"

IsDefined NEED_MAKE_DEPEND ||
    NEED_MAKE_DEPEND="${FALSE}"

IsDefined NEED_MAKE_TEST ||
    NEED_MAKE_TEST="${FALSE}"


[[ ${REPOSITORY_URL} =~ (.+)/$ ]] && REPOSITORY_URL="${BASH_REMATCH[1]}"


_cwd=$(pwd); cd "${TEMP_DIR_PATH}"
_dir_package="${PACKAGE_NAME}-${PACKAGE_VERSION}"
_symlink_package="${PACKAGE_NAME}"


# WGET
for _extension in tgz tar.gz
do
    _file_package_archive="${_dir_package}.${_extension}"
    _url_package_archive="${REPOSITORY_URL}/${_file_package_archive}"

    if WgetURLCheck "${_url_package_archive}"
    then
        break
    fi
done

wget -O "${_file_package_archive}" "${_url_package_archive}"


# DEARCHIVE
tar zxf ${_file_package_archive}


# CONFIGURE
cd "${_dir_package}"
IsDefined CONFIGURE_COMMAND && SetConfigureProgram "${CONFIGURE_COMMAND}"
IsDefined CONFIGURE_OPTION && SetConfigureOption "${CONFIGURE_OPTION}"
SetConfigureOption "--prefix=${INSTALL_PATH}"

DoConfigure || Abort


# MAKE
SetMake "${TRUE}"
SetMakeTest "${FALSE}"
[ "${NEED_MAKE_TEST,,}" = "${TRUE}" ] && SetMakeTest "${TRUE}"
SetMakeDependency "${FALSE}"
[ "${NEED_MAKE_DEPEND,,}" = "${TRUE}" ] && SetMakeDependency "${TRUE}"
SetMakeInstall "${TRUE}"

DoMakeDependency || Abort
DoMake || Abort
DoMakeTest || Abort
DoMakeInstall || Abort


# SYMLINK
if [ "${MAKE_SYMLINK,,}" = "${TRUE}" ]
then
    ln -s -f "${INSTALL_PATH}" "${SYMLINK_PATH}"
fi


cd "${_cwd}"


exit

