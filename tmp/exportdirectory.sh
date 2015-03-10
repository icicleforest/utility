#!/bin/sh


_host_src="$(hostname)"
_host_dst="${1}"
[ -z "${_host_dst}" ] && exit 1




_file_list="files.info"


_cwd=$(pwd)

for _leaf in `find ./`
do
    _name=${_leaf}
    _stat=$(stat "${_leaf}" -c "%u:%g:%a")
    echo "${_name}=${_stat}"
done > "${_file_list}"


if ! cd ../ 2>/dev/null
then
    cd "${_cwd}"
    exit 1
fi

scp -pr -l 16000 ${_cwd} ${_host_dst}:${_cwd}.from.${_host_src}


cd "${_cwd}"
exit

