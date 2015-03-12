#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/sqlite.shh"



# MAIN PROCESS
_db="/tmp/t_sqlite.db"


if ! SqliteCheckDatabaseFile "${_db}"
then
pwd
    echo "DBFile ${_db} is not existing."

    SqliteCreateDatabaseFile "${_db}" || Abort
    echo "DBFile is created."
else
    echo "DBFile ${_db} is exisiting."
fi

_SqliteGetDatabaseFile && Abort
echo "DBFile is not set."

SqliteSetDatabaseFile "${_db}" || Abort
echo "DBFile is set to ${_db}."

_SqliteGetDatabaseFile || Abort
echo "DBFile is set."

SqliteUnsetDatabaseFile || Abort
echo "DBFile is unset."

SqliteSetDatabaseFile "${_db}" || Abort
echo "DBFile is set to ${_db}."

#SqliteExecuteSQL "CREATE TABLE test(id INTEGER PRIMARY KEY, name TEXT, value TEXT);" || Abort
#SqliteExecuteSQL "INSERT INTO test(name, value) VALUES('key1', 'value1');" || Abort

SqliteExecuteSQL "SELECT * FROM test WHERE 1";
while :
do
    SqliteFetchResult _var
    _result="${?}"

    if [ ! "${_result}" = 0 ]
    then
        echo "Finish"
        break
    fi

    echo "> ${_var}"
done

SqliteUnsetDatabaseFile || Abort


exit

