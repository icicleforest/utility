#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/std.shh"
Include "../lib/lock.shh"



# MAIN PROCESS
echo "### Empty check"
Lock::Check && Std::Abort
echo "Pass"

echo "### Empty lock"
Lock::Get || Std::Abort
echo "Pass"

echo "### Locked check"
Lock::Check || Std::Abort
echo "Pass"

echo "### Locked release"
Lock::Release || Std::Abort
echo "Pass"

echo "### Empty check"
Lock::Check && Std::Abort
echo "Pass"

echo "### Empty release"
Lock::Release && Std::Abort
echo "Pass"

echo "### Locked lock"
Lock::Get
Lock::Get && ( Lock::Release; Std::Abort )
echo "Pass"

Lock::Release


echo "######"
echo "Test OK"

exit

