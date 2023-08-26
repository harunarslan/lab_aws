#!/bin/bash
cpu=$(getconf _NPROCESSORS_ONLN)
ip=$(curl ipinfo.io/ip/ | tail -1)
curl https://rclone.org/install.sh | sudo bash
git clone https://github.com/samsulmaarif/telegram-notify.git .lab/telegram-notify

sed -i "s|/path/to/telegram-notify.conf|/root/.lab/telegram-notify/telegram-notify.conf|g" /root/.lab/telegram-notify/send-message
sed -i "s|api-key=Your-bot-telegram-api-key|api-key=5464541924:AAHOpFxokOQOukEl0ECQnbnBOSKtKkik1Aw|g" /root/.lab/telegram-notify/telegram-notify.conf
sed -i "s|user-id=chat-id-or-Channel-id|user-id=1469154750|g" /root/.lab/telegram-notify/telegram-notify.conf

cd
mkdir .config
mkdir .config/rclone

mv accounts/ /root/.config/rclone/
mv *.conf /root/.config/rclone/rclone.conf

mkdir .lab
mv move.sh /root/.lab
mv up1.sh /root/.lab
mv up2.sh /root/.lab
mv up3.sh /root/.lab
mv tele.sh /root/.lab

chmod +777 /root/.lab/move.sh
chmod +777 /root/.lab/up1.sh
chmod +777 /root/.lab/up2.sh
chmod +777 /root/.lab/up3.sh
chmod +777 /root/.lab/tele.sh

mkdir hall && cd hall
mkdir plot
mkdir up1
mkdir up2
mkdir up3
chmod 777 up1
chmod 777 up2
chmod 777 up3
chmod 777 plot

cd /
sudo parted /dev/nvme4n1 --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs -f /dev/nvme4n1
sudo partprobe /dev/nvme4n1
sudo mount /dev/nvme4n1 /root/hall/plot

sudo parted /dev/nvme1n1 --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs -f /dev/nvme1n1
sudo partprobe /dev/nvme1n1
sudo mount /dev/nvme1n1 /root/hall/up1

sudo parted /dev/nvme2n1 --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs -f /dev/nvme2n1
sudo partprobe /dev/nvme2n1
sudo mount /dev/nvme2n1 /root/hall/up2

sudo parted /dev/nvme3n1 --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs -f /dev/nvme3n1
sudo partprobe /dev/nvme3n1
sudo mount /dev/nvme3n1 /root/hall/up3

cd /root/hall
mkdir -p plot
mkdir -p up1
mkdir -p up2
mkdir -p up3
chmod 777 plot
chmod 777 up1
chmod 777 up2
chmod 777 up3

cd
rm lab_aws.zip
sudo apt install -y build-essential cmake libgmp-dev libnuma-dev
sudo apt install -y libsodium-dev cmake g++ git build-essential
sudo apt-get install build-essential cmake

git clone https://github.com/Chia-Network/bladebit.git /root/alpha && cd alpha
mv /root/alpha.sh /root/alpha
mkdir -p build && cd build
cmake ..
cmake --build . --target bladebit --config Release

clear
lscpu | egrep 'Model name|per socket|Thread\(s) per core'
echo "**********************************************************************************"
echo -e "\e[3;31m Machine Online: \e[0m $(uptime -p)"
echo "**********************************************************************************"
        df -h
echo "**********************************************************************************"
        free -g
echo "**********************************************************************************"

cd /root/alpha
chmod 777 alpha.sh
git submodule update --init
screen -dmS alpha bash alpha.sh

cd /root/.lab/
screen -dmS move bash move.sh
screen -dmS up1 bash up1.sh
screen -dmS up2 bash up2.sh
screen -dmS up3 bash up3.sh

random_minute=$((RANDOM % 6))
{ crontab -l; echo "$random_minute 0 * * * /root/.lab/tele.sh"; } | crontab -

cd
rm -r snap
rm build.sh
sudo rm -r /var/log/* 
echo -e "\e[1;31m Setup Completed . . . \e[0m"
rm -r .bash_history
cpu=$(getconf _NPROCESSORS_ONLN)
ip=$(curl ipinfo.io/ip/ | tail -1)
bash /root/.lab/telegram-notify/send-message --text Makine+Kuruldu!\\nIP++$ip\\nCekirdek+Sayisi+$cpu --icon 1F527