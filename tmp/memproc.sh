#!/bin/bash

#_dir_log=$(dirname $0)
#_file_log="$(basename $0).log"

#_time_start="1day 01:19"
#_time_end="1 day 01:51"
#_time_start="22:12"
#_time_end="22:13"
#_time_sleep=5


#_path_log="${_dir_log}/${_file_log}"

#Write()
#{
#    local _msg="${@}"
#    local _date="$(date +%Y/%m/%d-%H:%M:%S)"
#
#    echo -n "[${_date}]" >> ${_path_log}
#    echo "${_msg:+ }${_msg}" >> ${_path_log}
#}

#Archive()
#{
#    gzip ${_path_log}
#    /bin/mv -f ${_path_log}.gz ${_path_log}.$(date +%Y%m%d-%H%M%S).gz
#}


_size_page=$(getconf PAGE_SIZE)
#_t_start=$(date -d "${_time_start}" +%s)
#_t_end=$(date -d "${_time_end}" +%s)


#Write "Start logging"

#while :
#do
#    _t_now=$(date +%s)
#    if ((_t_start > _t_now))
#    then
#        sleep ${_time_sleep}
#        continue
#    elif ((_t_end < _t_now))
#    then
#        break
#    fi
#
#    Write "$(uptime | egrep -o 'load average:.*')"
#    Write "$(echo "mpstat"; mpstat -P ALL)"

    _procs=$(find /proc -maxdepth 1 -type d -name [0-9]*)
#    _data="$(echo "memory usage"; (
        for _proc in ${_procs}
        do
            cat ${_proc}/stat 2>/dev/null | awk '{ print $1,$2,$3,$23,$24 }' | while read _pid _cmd _stat _vm _pp
            do
                ((_pm = _pp * _size_page / 1024 / 1024))
                ((_vm = _vm / 1024 / 1024))
                echo "${_pm}MB > pid=${_pid} cmd=${_cmd} stat=${_stat} pm=${_pm}MB vm=${_vm}MB"
            done
        done
#        ) | sort -nr | grep -v "^0MB" )"
#    Write "${_data}"
#    sync
#
#    ((_n = _n + 1))
#    sleep ${_time_sleep}
#done

#Write "End logging"
#Archive

exit

