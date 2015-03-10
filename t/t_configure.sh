#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/const.shh"
Include "../lib/stdfunc.shh"
Include "../lib/stdutil.shh"
Include "../lib/configure.shh"



# MAIN PROCESS
GetConfigureOption || Abort
SetConfigureOption && Abort
GetConfigureOption || Abort

SetConfigureOption "--prefix=/test/test/test" || Abort
GetConfigureOption || Abort

SetConfigureOption "-DTEST" || Abort
GetConfigureOption || Abort

echo "Try to exec ./[cC]onfig*"
if DoConfigure
then
    echo Configure OK
else
    echo Configure NG
fi

echo "Set config program ./test.sh"
SetConfigureProgram "./test.sh"

echo "Try to exec specified program"
if DoConfigure
then
    echo Configure OK
else
    echo Configure NG
fi


exit

