#!/bin/bash

Include()
{
    [ ! -z "${1}" ] && source "$(dirname ${0})/${1}" || exit
}



# INCLUDE DEPENDENCY
Include "../lib/sqlite.shh"



# MAIN PROCESS
_db="/tmp/t_sqlite.db"


if ! Sqlite::CheckDatabaseFile "${_db}"
then
pwd
    echo "DBFile ${_db} is not existing."

    Sqlite::CreateDatabaseFile "${_db}" || Std::Abort
    echo "DBFile is created."
else
    echo "DBFile ${_db} is exisiting."
fi

Sqlite::_GetDatabaseFile && Std::Abort
echo "DBFile is not set."

Sqlite::SetDatabaseFile "${_db}" || Std::Abort
echo "DBFile is set to ${_db}."

Sqlite::_GetDatabaseFile || Std::Abort
echo "DBFile is set."

Sqlite::UnsetDatabaseFile || Std::Abort
echo "DBFile is unset."

Sqlite::SetDatabaseFile "${_db}" || Std::Abort
echo "DBFile is set to ${_db}."

#SqliteExecuteSQL "CREATE TABLE test(id INTEGER PRIMARY KEY, name TEXT, value TEXT);" || Std::Abort
#SqliteExecuteSQL "INSERT INTO test(name, value) VALUES('key1', 'value1');" || Std::Abort

Sqlite::ExecuteSQL "SELECT * FROM test WHERE 1";
while :
do
    Sqlite::FetchResult _var
    _result="${?}"

    if [ ! "${_result}" = 0 ]
    then
        echo "Finish"
        break
    fi

    echo "> ${_var}"
done

Sqlite::UnsetDatabaseFile || Std::Abort


exit

