#!/bin/bash

source functions.sh

# prepare for installations
init

# install firefox
if alreadyInstalled firefox
then
	echo "[OK] Firefox already installed."
else
	installFromRepo "Firefox" "firefox"
fi

# install django
echo -ne "Installing Django...\r"
pip3 install --upgrade django 1>/dev/null
if [ $? == 0 ]
then
    echo "[DONE] Installing Django."
else
	echo "[FAILED] Installing Django."
fi

# install Selenium
echo -ne "Installing Selenium...\r"
pip3 install --upgrade selenium 1>/dev/null
if [ $? == 0 ]
then
    echo "[DONE] Installing Selenium."
else
	echo "[FAILED] Installing Selenium."
fi