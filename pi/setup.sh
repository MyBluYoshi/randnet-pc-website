#!/bin/bash
#Based on XbandPi Setup
#Requires a basic install of DreamPi 1.7 Image
#If you use it, this will turn DreamPi into RandnetPi and won't do DreamPi stuff anymore.
#MIND YOU, this won't work on its own but it's a good start!

if [ "$(id -u)" -ne 0 ]; then echo "Please run as root, such as using sudo." >&2; exit 1; fi

echo Turning your DreamPi into RandnetPi...

echo - Updating dnsmasq config...
# Use a public DNS
sed -i -e 's/server=129.159.86.247/server=8.8.8.8/' /etc/dnsmasq.conf
systemctl restart dnsmasq
sleep 2

echo - Disabling DreamPi...
systemctl disable dreampi

echo - Stopping DreamPi...
systemctl stop dreampi
sleep 5
#Make sure DreamPi Python is closed.
killall -9 python

#Prep RandnetPi
mkdir ~pi/randnetpi
echo - Downloading RandnetPi Python Script...
wget -O ~pi/randnetpi/randnetpi.py https://64dd.org/pi/randnetpi
chmod +x ~pi/randnetpi/randnetpi.py

echo - Copy stuff from DreamPi...
cp ~pi/dreampi/dial-tone.wav ~pi/randnetpi/
chown -R pi:pi ~pi/dreampi/

echo - Downloading and setting up initscript...
cd /tmp
wget -O randnetpi https://64dd.org/pi/init
mv randnetpi /etc/init.d/randnetpi
chmod +x /etc/init.d/randnetpi
systemctl daemon-reload
systemctl enable randnetpi

echo - Starting RandnetPi...
/etc/init.d/randnetpi start
sleep 5

exit 0
