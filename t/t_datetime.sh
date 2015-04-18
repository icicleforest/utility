#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/datetime.shh"



# MAIN PROCESS
Datetime::Current "-" " " ":"
Datetime::Current "" "_" ""

