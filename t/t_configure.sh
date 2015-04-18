#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/std.shh"
Include "../lib/stdutil.shh"
Include "../lib/configure.shh"



# MAIN PROCESS
GetConfigureOption || Std::Abort
SetConfigureOption && Std::Abort
GetConfigureOption || Std::Abort

SetConfigureOption "--prefix=/test/test/test" || Std::Abort
GetConfigureOption || Std::Abort

SetConfigureOption "-DTEST" || Std::Abort
GetConfigureOption || Std::Abort

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

echo "######"
echo "Test OK"

exit

