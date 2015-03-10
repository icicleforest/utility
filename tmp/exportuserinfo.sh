#!/bin/bash

Abort()
{
    exit 1
}

Return()
{
    exit 0
}


_conf="$(dirname $0)/../etc/conf"

if [ -r "${_conf}" ]
then
    . "${_conf}"
else
    Abort
fi


declare -a _userinfos
for _user in ${_users_target}
do
    _userinfo=$(LANG=C id -a ${_user} 2>/dev/null | tr ' ' ':')
    if [ ! $? = 0 ]
    then
        _userinfo="unknown"
    fi

    _home=$(cat /etc/passwd | grep ^"${_user}:" | cut -d ':' -f 6)
    _perm=$(stat -c %a ${_home})

    _userinfo="${_userinfo}:${_home}:${_perm}"

    _userinfos=(${_userinfos[@]} ${_userinfo})
done


_file_export=$(mktemp)
for _userinfo in ${_userinfos[@]}
do
    echo "${_userinfo}" >> "${_file_export}"
done

echo "Exported to ${_file_export}"
exit

