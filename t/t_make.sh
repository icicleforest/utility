#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/const.shh"
Include "../lib/stdfunc.shh"
Include "../lib/make.shh"




# MAIN PROCESS

_GetMakeStatus

## MAKE
echo "=== make ==="
SetMake "${TRUE}" || Abort

_GetMakeStatus

SetMake "${FALSE}" || Abort

_GetMakeStatus

SetMake "${TRUE}" || Abort

_GetMakeStatus


## MAKE TEST
echo "=== make test ==="
SetMakeTest "${TRUE}" || Abort

_GetMakeStatus

SetMakeTest "${FALSE}" || Abort

_GetMakeStatus

SetMakeTest "${TRUE}" || Abort

_GetMakeStatus


## MAKE INSTALL
echo "=== make install ==="
SetMakeInstall "${TRUE}" || Abort

_GetMakeStatus

SetMakeInstall "${FALSE}" || Abort

_GetMakeStatus

SetMakeInstall "${TRUE}" || Abort

_GetMakeStatus


## MAKE DEPENDENCY
echo "=== make depend ==="
SetMakeDependency "${TRUE}" || Abort

_GetMakeStatus

SetMakeDependency "${FALSE}" || Abort

_GetMakeStatus

SetMakeDependency "${TRUE}" || Abort

_GetMakeStatus

exit

