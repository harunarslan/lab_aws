#!/bin/bash
sort /root/.lab/report | uniq | sed '/^$/d' > /root/.lab/reportX
aktarilan=$(wc -l /root/.lab/reportX)
cpu=$(getconf _NPROCESSORS_ONLN)
id=($(cat /root/.lab/id))
ip=$(curl ipinfo.io/ip/ | tail -1)
#uptime=$(uptime -p | grep -o '[0-9]*')
bash /root/.lab/telegram-notify/send-message --text $id\\nIP++$ip\\nCekirdek+Sayisi+$cpu\\nYapilan+uretim+$aktarilan --icon 1F331
rm -r /root/.lab/report
rm -r /root/.lab/reportX
