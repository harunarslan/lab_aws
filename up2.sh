#!/bin/bash
cpu=$(getconf _NPROCESSORS_ONLN)
ip=$(curl ipinfo.io/ip/ | tail -1)
try=0
userRateLimitExceededCount=0
file_count=$(ls /root/.config/rclone/accounts | wc -l)
last_remote=$(grep -Po '(?<=^\[)[^]]*' "/root/.config/rclone/rclone.conf" | tail -n 1)
remote_number=$(echo "$last_remote" | sed 's/[^0-9]*//g')

while true; do
    try=$(($try + 1))
    echo -e "\e[3;31m TRY: $try \e[0m"
    echo ""

    count=0
    count=($(ls /root/hall/up2/ | wc -l))
    echo -e "\e[3;36m Plot Count: $count \e[0m"
    echo " "

    if [[ $count -gt 0 ]]; then
        if [[ $userRateLimitExceededCount -eq 1 ]]; then
            echo -e "\e[3;33m User rate limit exceeded. Reached to limit! \e[0m"
            bash /root/.lab/telegram-notify/send-message --text up+$slot\\nIP++$ip\\nCekirdek+Sayisi+$cpu\\nUpload+Eror++$index.json --icon 1F527
            index=1
            echo -e "\e[3;36m Service Account: $index (Reached to limit!) \e[0m"
            userRateLimitExceededCount=0
        else
            echo -e ""
        fi

        slot=$((($RANDOM % $remote_number ) + 1))
        echo -e "\e[3;36m Service Slot: $slot \e[0m"

        index=$((($RANDOM % $file_count) + 1))
        echo -e "\e[3;36m Service Account: $index \e[0m"

        echo -e "\e[3;32m Transfer Starting ... (up$slot - $index using) \e[0m"
        ls /root/hall/up2/*.plot >> /root/.lab/report
        rclone move /root/hall/up2/ "up$slot"crypt: --include "*.plot" --buffer-size=32M --drive-chunk-size=16M --drive-upload-cutoff=1000T --drive-pacer-min-sleep=700ms --checksum --check-first --drive-acknowledge-abuse --copy-links --drive-stop-on-upload-limit --no-traverse --tpslimit-burst=0 --retries=3 --low-level-retries=10 --checkers=14 --tpslimit=3 --transfers=7 --fast-list --user-agent="ISV|rclone.org|rclone/v1.61.0-beta.6610.beea4d511" --drive-service-account-file "/root/.config/rclone/accounts/$index.json" -P
        if [[ $? -eq 0 ]]; then
            echo -e "\e[3;32m Transfer Done ... \e[0m"
        else
            echo -e "\e[3;31m Transfer Failed ... \e[0m"
            if [[ $index -eq 1 ]]; then
                userRateLimitExceededCount=$(($userRateLimitExceededCount + 1))
            fi
        fi

        echo "********************************************************"
    fi
    sleep 60
done
