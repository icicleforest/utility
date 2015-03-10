#!/bin/sh


_file_list="files.info"
[ ! -r "${_file_list}" ] && exit 1


_cwd=$(pwd)


_old_ifs="${IFS}"
IFS="="
while read _name _uga
do
    _own=$(echo "${_uga}" | cut -d ":" -f 1-2)
    _mod=$(echo "${_uga}" | cut -d ":" -f 3)

    if [ -e "${_name}" ]
    then
        chown ${_own} ${_name}
        chmod ${_mod} ${_name}
    fi
done < "${_file_list}"
IFS="${_old_ifs}"


cd "${_cwd}"
exit

