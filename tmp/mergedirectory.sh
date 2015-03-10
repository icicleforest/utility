#!/bin/bash

_path_src_dir="${1}"
_path_dst_dir="${2}"
[ -z "${_path_src_dir}" -o -z "${_path_dst_dir}" ] && exit 1


_is_verbose="true"
Print()
{
    [ ! "${_is_verbose}" = "true" ] && return 0
    echo "${@}"
    sleep 1

    return 0
}

_do_execute="false"
Execute()
{
    [ ! "${_do_execute}" = "true" ] && return 0
    ${@}
    sleep 1

    return 0
}



_cwd=$(pwd)


# SOURCE DISCOVERY
cd "${_path_src_dir}"
_directories_src=$(find "./" -mindepth 1 -type d)

cd "${_cwd}"


# CHECK AND CREATE DIRECTORIES
cd "${_path_dst_dir}"
for _directory in ${_directories_src}
do
    if [ ! -d "${_directory}" ]
    then
        Print "mkdir ${_path_dst_dir}/${_directory}"
        Execute "mkdir ${_path_dst_dir}/${_directory}"
    fi

    _user_src=$(stat -c %u "${_path_src_dir}/${_directory}" 2>/dev/null)
    _user_dst=$(stat -c %u "${_path_dst_dir}/${_directory}" 2>/dev/null)
    if [ ! "${_user_src}" = "${_user_dst}" ]
    then
        Print "chown ${_user_src} ${_path_dst_dir}/${_directory}"
        Execute "chown ${_user_src} ${_path_dst_dir}/${_directory}"
    fi

    _group_src=$(stat -c %g "${_path_src_dir}/${_directory}" 2>/dev/null)
    _group_dst=$(stat -c %g "${_path_dst_dir}/${_directory}" 2>/dev/null)
    if [ ! "${_group_src}" = "${_group_dst}" ]
    then
        Print "chgrp ${_group_src} ${_path_dst_dir}/${_directory}"
        Execute "chgrp ${_group_src} ${_path_dst_dir}/${_directory}"
    fi

    _mode_src=$(stat -c %a "${_path_src_dir}/${_directory}" 2>/dev/null)
    _mode_dst=$(stat -c %a "${_path_dst_dir}/${_directory}" 2>/dev/null)
    if [ ! "${_mode_src}" = "${_mode_dst}" ]
    then
        Print "chmod ${_mode_src} ${_path_dst_dir}/${_directory}"
        Execute "chmod ${_mode_src} ${_path_dst_dir}/${_directory}"
    fi
done

cd "${_cwd}"


# CHECK AND MOVE FILES
cd "${_path_src_dir}"
_files_src=$(find "./" -type f)
for _file in ${_files_src}
do
    _path_src="${_path_src_dir}/${_file}"
    _path_dst="${_path_dst_dir}/${_file}"
    if [ ! -f "${_path_dst}" ]
    then
        Print "mv -iv ${_path_src} ${_path_dst}"
        Execute "mv -iv ${_path_src} ${_path_dst}"
        continue
    fi

    _change_src=$(stat -c %Z "${_path_src}" 2>/dev/null)
    _change_dst=$(stat -c %Z "${_path_dst}" 2>/dev/null)
    if [ -n "${_change_src}" -a -n "${_change_dst}" ] && [ "${_change_src}" -gt "${_change_dst}" ]
    then
        Print "mv -fv ${_path_src} ${_path_dst}"
        Execute "cp -fv ${_path_src} ${_path_dst}"
        continue
    fi

    _user_src=$(stat -c %u "${_path_src}" 2>/dev/null)
    _user_dst=$(stat -c %u "${_path_dst}" 2>/dev/null)
    if [ ! "${_user_src}" = "${_user_dst}" ]
    then
        Print "chown ${_user_src} ${_path_dst}"
        Execute "chown ${_user_src} ${_path_dst}"
    fi

    _group_src=$(stat -c %g "${_path_src}" 2>/dev/null)
    _group_dst=$(stat -c %g "${_path_dst}" 2>/dev/null)
    if [ ! "${_group_src}" = "${_group_dst}" ]
    then
        Print "chgrp ${_group_src} ${_path_dst}"
        Execute "chgrp ${_group_src} ${_path_dst}"
    fi

    _mode_src=$(stat -c %a "${_path_src}" 2>/dev/null)
    _mode_dst=$(stat -c %a "${_path_dst}" 2>/dev/null)
    if [ ! "${_mode_src}" = "${_mode_dst}" ]
    then
        Print "chmode ${_mode_src} ${_path_dst}"
        Execute "chmode ${_mode_src} ${_path_dst}"
    fi
done


exit

