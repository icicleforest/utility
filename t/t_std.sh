#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/std.shh"



# MAIN PROCESS
echo "### Before calling ImportNamespace"
for _key in TRUE FALSE ${!RC_*}
do
    echo "${_key} => ${!_key}"
done


echo "### call ImportNamespace"
Std::ImportNamespace || exit 1
echo "Import OK"


echo "### After calling ImportNamespace"
for _key in TRUE FALSE ${!RC_*}
do
    echo "${_key} => ${!_key}"
done


echo "######"


echo "### Function Test"
if ! Std::IsDefined _var
then
    echo "IsDefined returns false: OK"
else
    echo "Failed"
    Std::Abort
fi

_var=0
if Std::IsDefined _var
then
    echo "IsDefined returns true: OK"
else
    echo "Failed"
    Std::Abort
fi

_var="${Std__TRUE}"
if Std::IsTrue _var
then
    echo "IsTrue returns true: OK"
else
    echo "Failed"
    Std::Abort
fi


echo "######"
echo "Test OK"

exit

