#!/bin/bash

[ -z "${1}" ] && cat <<MSG
Usage: $0 \$binary_name
MSG


_binname="${1}"
_binfile="${_binname}.sh"

if [ -e "${_binfile}" ]
then
    cat <<MSG
Error: "${_binname}" is already existing.
MSG
    exit
fi



cat <<BIN > "${_binfile}"
#!/bin/bash

Include()
{
    [ ! -z "\${1}" ] && source "\$(dirname \${0})/\${1}" || exit
}



# INCLUDE DEPENDENCY



# MAIN PROCESS

BIN

exit

