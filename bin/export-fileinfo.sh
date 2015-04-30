#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/std.shh"
Include "../lib/auxiliary.shh"



# MAIN PROCESS
_out="${1}"

Std::IsDefined _out || Std::Abort
Auxiliary::File::SetOutput ${_out}
if Auxiliary::File::Load
then
    echo "Exported to ${_out}."
else
    echo "Failed to export."
fi


exit 0

