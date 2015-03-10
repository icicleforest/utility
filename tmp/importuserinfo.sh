#!/bin/bash

Abort()
{
    exit 1
}


_file=$1
[ -z "${_file}" ] && Abort
[ -r "${_file}" ] || Abort

_old_ifs="${IFS}"
IFS=':'
while read _str_uid _str_gid _str_groups _str_home _str_perm
do
    [ "${_str_uid}" = "unknown" ] && continue

    #echo "UID=${_str_uid}"
    #echo "GID=${_str_gid}"
    #echo "Goups=${_str_groups}"
    #echo "Home=${_str_home}"
    #echo "Permission=${_str_perm}"

    # USER
    _user=$(echo "${_str_uid}" | perl -e '
        while (my $line = <>) {
            chomp($line);
            $line =~ /^uid=\d+\(([^\)]+)\)$/;
            print $1, "\n";
        }
    ')

    # UID
    _uid=$(echo "${_str_uid}" | egrep -o "uid=[0-9]+" | cut -d '=' -f 2)

    # GID
    _gid=$(echo "${_str_gid}" | egrep -o "gid=[0-9]+" | cut -d '=' -f 2)

    # Groups
    _groups=$(echo "${_str_groups}" | cut -d ',' -f 2- | perl -e '
        while (my $line = <>) {
            chomp($line);
            $line =~ s/\s*\([^\)]+\)\s*//g;
            print $line, "\n";
        }
    ') 

    # Home
    _home="${_str_home}"

    # Permission
    _perm=${_str_perm}



    if ! LANG=C id "${_user}" >/dev/null 2>&1
    then
        echo "useradd -u ${_uid} -g ${_gid} -G ${_groups} -d ${_home} ${_user}"
        echo "chmod ${_perm} ${_home}"
        continue
    fi


    _uid_cur=$(LANG=C id ${_user} | perl -e '
        while (my $line = <>) {
            chomp($line);
            $line =~ /uid=(\d+)/;
            print $1, "\n";
        }
    ')

    if [ ! "${_uid}" = "${_uid_cur}" ]
    then
        echo "usermod -u ${_uid} ${_user}"
    fi


    _gid_cur=$(LANG=C id ${_user} | perl -e '
        while (my $line = <>) {
            chomp($line);
            $line =~ /gid=(\d+)/;
            print $1, "\n";
        }
    ')

    if [ ! "${_gid}" = "${_gid_cur}" ]
    then
        echo "usermod -g ${_gid} ${_user}"
    fi


    _groups_cur=$(LANG=C id ${_user} | perl -e '
        while (my $line = <>) {
            chomp($line);
            $line =~ /groups=(.+)/;
            my $serialized = $1;
            $serialized =~ s/\([^\)]+\)//g;
            print $serialized, "\n";
        }
    ' | cut -d ',' -f 2-)

    echo "### groups(${_groups}) <=> groups_cur(${_groups_cur}) ###"
    if [ ! "${_groups}" = "${_groups_cur}" ]
    then
        echo "usermod -G ${_groups} ${_user}"
    fi


    _home_cur=$(grep ${_user} /etc/passwd | cut -d ':' -f 6)
    _perm_cur=$(stat -c %a "${_home_cur}" 2>/dev/null)

    if [ ! -d "${_home}" ]
    then
        echo "mkdir ${_home}"
        echo "chown ${_uid}:${_gid} ${_home}"
        echo "chmod ${_perm} ${_home}"
        continue
    elif [ ! "${_home}" = "${_home_cur}" ]
    then
        echo "usermod -d ${_home} ${_user}"
        echo "mv -iv ${_home_cur} ${_user}"
    fi

    if [ ! "${_perm}" = "${_perm_cur}" ]
    then
        echo "chmod ${_perm} ${_home}"
    fi

done < "${_file}"
IFS="${_old_ifs}"



exit

