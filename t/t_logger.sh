#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/logger.shh"



# MAIN PROCESS
Logger::MessageInfo "test"
sleep 1
Logger::MessageWarn "test2"
sleep 1
Logger::MessageErr "test3"

