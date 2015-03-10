#!/bin/bash

if [ -z "${1}" ]
then
    cat <<MSG
Usage: $0 \$library_name
MSG
    exit 1
fi


_libname="${1}"
_libfile="${_libname}.shh"

if [ -e "${_libfile}" ]
then
    cat <<MSG
Error: "${_libname}" is already existing.
MSG
    exit
fi



cat <<LIB > "${_libfile}"
[ -z "\${___${_libname^^}-shh}" ] && return
___${_libname^^}=



### DEPENDENCY ###



### DEFINITION ###

LIB

exit

