#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/datetime.shh"
Include "../lib/logging.shh"
Include "../lib/const.shh"
Include "../lib/lock.shh"



# MAIN PROCESS
for i in 1 2
do


if GetLock
then
    echo "Lock OK"
else
    echo "Lock NG"
fi

if CheckLocked
then
    echo "Locked"
else
    echo "Unlocked"
fi

if ReleaseLock
then
    echo "Unlock OK"
else
    echo "Unlock NG"
fi

if CheckLocked
then
    echo "Locked"
else
    echo "Unlocked"
fi


done

exit

