#!/bin/bash
# 权限必须744
status=$(ps -ef | grep [e]lasticsearch | grep -v ${0} | wc -l)
if [ ${status} -eq 0 ]; then
    systemctl stop keepalived
    exit 1
else
    exit 0
fi
