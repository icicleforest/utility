#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/monitor.shh"



# MAIN PROCESS
for _p in $(Monitor::Process::GetAllPids)
do
    _stat=$(Monitor::Process::GetStat ${_p})
    if [ $? = 0 ]
    then
        echo "# ${_p} $(Monitor::Process::GetUsedPhysicalMemorySize ${_p})"
    fi
done

exit

