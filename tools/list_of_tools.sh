# This file contains the list of all tools for the install script
#
# Author Name: Ognjen Vukovic
# Author Email: ognjen.m.vukovic@gmail.com
# Date: Sept 2017
#

# INSTRUCTIONS
#
# To add a new tool to the list:
# 1. Select the category, and make sure it is added together with tools from that category.
#   a. If really needed, add a new category.
# 2. Enter the tool name preceeded with ##
# 3. Add the following 5 rows for each tool. There MUST exist all 5 entries.
#    tools_name+=("User-friendly name")
#    tools_command_getStatus+=("Command for checking that returns 0 if already installed")
#    tools_command_install+=("Command(s) for installing the tool")
#    tools_command_postinstall+=("Command(s) to be run after the install is completed")
#    tools_category+=("$category")
#   a. If one of the entries requires multiple commands, they MUST be connected with '&&' and a special care is required for "" and ''
#       For example:
#           tools_command_install+=('
#               addRepo sublime-text "https://download.sublimetext.com/ apt/stable/" "https://download.sublimetext.com/sublimehq-pub.gpg" &&
#               sudo apt-get -y install sublime-text
#           ')
#

# Web Browsers
category="Web Browsers"
## Google Chrome
tools_name+=("Google Chrome")
tools_command_getStatus+=("dpkg -s google-chrome-stable")
tools_command_install+=('
    addRepo google-chrome "[arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" "https://dl.google.com/linux/linux_signing_key.pub" &&
    sudo apt-get -y install google-chrome-stable
    ')
tools_command_postinstall+=("google-chrome")
tools_category+=("$category")
## Google Chromium
tools_name+=("Google Chromium")
tools_command_getStatus+=("dpkg -s chromium-browser")
tools_command_install+=("sudo apt-get -y install chromium-browser")
tools_command_postinstall+=("chromium-browser")
tools_category+=("$category")
## Firefox
tools_name+=("Firefox")
tools_command_getStatus+=("dpkg -s firefox")
tools_command_install+=("sudo apt-get -y install firefox")
tools_command_postinstall+=("")
tools_category+=("$category")

# Editors
category="Source Code Editors"
## VS Code
tools_name+=("VS Code")
tools_command_getStatus+=("dpkg -s code")
tools_command_install+=('
    addRepo vscode "[arch=amd64] https://packages.microsoft.com/repos/vscode stable main" "https://packages.microsoft.com/keys/microsoft.asc" &&
    sudo apt-get -y install code &&
    code --install-extension ms-vscode.cpptools &&
    code --install-extension donjayamanne.python &&
    code --install-extension ms-vscode.sublime-keybindings
    ')
tools_command_postinstall+=("code")
tools_category+=("$category")
## Sublime
tools_name+=("Sublime")
tools_command_getStatus+=("dpkg -s sublime-text")
tools_command_install+=('
    addRepo sublime-text "https://download.sublimetext.com/ apt/stable/" "https://download.sublimetext.com/sublimehq-pub.gpg" &&
    sudo apt-get -y install sublime-text
    ')
tools_command_postinstall+=("subl")
tools_category+=("$category")
## ReText - A Simple Markdown Text Editor and Viewer
tools_name+=("ReText")
tools_command_getStatus+=("dpkg -s retext")
tools_command_install+=("sudo apt-get -y install retext")
tools_command_postinstall+=("")
tools_category+=("$category")

# Version Control
category="Version Control Tools"
## Git
tools_name+=("Git")
tools_command_getStatus+=("dpkg -s git")
tools_command_install+=("sudo apt-get -y install git")
tools_command_postinstall+=('
    echo "Configuring Git:" &&
    read -p "Git user.name: " gitusername &&
    read -p "Git user.email: " gitemail &&
    git config --global user.name "$gitusername" &&
    git config --global user.email "$gitemail" &&
    echo "[Done] Configuring Git." &&
    echo "[NOTE] Do not forget to copy your SSH keys to /home/$USER/.ssh/"
')
tools_category+=("$category")

# Programming Languages, Frameworks, and Build Tools
category="Programming Languages and Build Tools"
## Python2
tools_name+=("Python2")
tools_command_getStatus+=("dpkg -s python")
tools_command_install+=("sudo apt-get -y install python")
tools_command_postinstall+=("")
tools_category+=("$category")
## Python2-Pip
tools_name+=("Python2-Pip")
tools_command_getStatus+=("dpkg -s python-pip")
tools_command_install+=("sudo apt-get -y install python-pip")
tools_command_postinstall+=("pip install -q --upgrade pip")
tools_category+=("$category")
## Python3
tools_name+=("Python3")
tools_command_getStatus+=("dpkg -s python3")
tools_command_install+=("sudo apt-get -y install python3")
tools_command_postinstall+=("")
tools_category+=("$category")
## Python3-Pip
tools_name+=("Python3-Pip")
tools_command_getStatus+=("dpkg -s python3-pip")
tools_command_install+=("sudo apt-get -y install python3-pip")
tools_command_postinstall+=("pip3 install -q --upgrade pip")
tools_category+=("$category")
## G++
tools_name+=("G++")
tools_command_getStatus+=("dpkg -s g++")
tools_command_install+=("sudo apt-get -y install g++")
tools_command_postinstall+=("")
tools_category+=("$category")
## CMake
tools_name+=("CMake")
tools_command_getStatus+=("dpkg -s cmake")
tools_command_install+=("sudo apt-get -y install cmake")
tools_command_postinstall+=("")
tools_category+=("$category")
## Django
tools_name+=("Django")
tools_command_getStatus+=("pip3 show django")
tools_command_install+=("sudo -H pip3 install --upgrade django")
tools_command_postinstall+=("")
tools_category+=("$category")

# Database Tools
category="Databases and Database Tools"
## PostgreSQL
tools_name+=("PostgreSQL")
tools_command_getStatus+=("dpkg -s postgresql postgresql-contrib")
tools_command_install+=('sudo apt-get -y install postgresql postgresql-contrib')
tools_command_postinstall+=("")
tools_category+=("$category")
## SQLite Browser
tools_name+=("SQLite Browser")
tools_command_getStatus+=("dpkg -s sqlitebrowser")
tools_command_install+=('sudo apt-get -y install sqlitebrowser')
tools_command_postinstall+=("")
tools_category+=("$category")

# Testing Tools
category="Testing Tools"
## Google Test Tools
tools_name+=("Google Mock and Test Tools")
tools_command_getStatus+=("dpkg -s google-mock")
tools_command_install+=('
    sudo apt-get -y install google-mock &&
    cd /usr/src/gtest &&
    sudo cmake -E make_directory build &&
    sudo cmake -E chdir build cmake .. &&
    sudo cmake --build build &&
    sudo cp build/libgtest* /usr/local/lib/ &&
    sudo rm -rf build
    ')
tools_command_postinstall+=("")
tools_category+=("$category")
## Selenium
tools_name+=("Selenium")
tools_command_getStatus+=("pip3 show selenium")
tools_command_install+=("sudo -H pip3 install --upgrade selenium")
tools_command_postinstall+=("")
tools_category+=("$category")
## Selenium Chrome Driver
#tools_name+=("Selenium Chrome Driver")
#tools_command_getStatus+=("test -e /usr/bin/chromedriver")
#tools_command_install+=('
#    wget -q http://chromedriver.storage.googleapis.com/$(wget -qO- http://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip &&
#    unzip chromedriver_linux64.zip &&
#    chmod +x chromedriver
#    sudo mv -f chromedriver /usr/bin/chromedriver
#    ')
#tools_command_postinstall+=("")
#tools_category+=("$category")
## Selenium Chromium Driver
tools_name+=("Selenium Chromium Driver")
tools_command_getStatus+=("dpkg -s chromium-chromedriver")
tools_command_install+=('
    sudo apt-get install -y chromium-chromedriver &&
    sudo ln -s /usr/lib/chromium-browser/chromedriver /usr/bin/chromedriver
    ')
tools_command_postinstall+=("")
tools_category+=("$category")
## Selenium Firefox Driver
tools_name+=("Selenium Firefox Driver")
tools_command_getStatus+=("test -e /usr/bin/geckodriver")
tools_command_install+=('
    wget -q https://github.com/mozilla/geckodriver/releases/download/v0.19.0/geckodriver-v0.19.0-linux64.tar.gz &&
    tar -xf geckodriver-v0.19.0-linux64.tar.gz &&
    rm geckodriver-v0.19.0-linux64.tar.gz &&
    chmod +x geckodriver &&
    sudo mv -f geckodriver /usr/bin/geckodriver
    ')
tools_command_postinstall+=("")
tools_category+=("$category")

# Peformance Optimizers
category="Performance Optimizers"
## Google Performance Tools
tools_name+=("Google Performance Tools")
tools_command_getStatus+=("dpkg -s google-perftools libgoogle-perftools-dev")
tools_command_install+=("sudo apt-get -y install google-perftools libgoogle-perftools-dev")
tools_command_postinstall+=("")
tools_category+=("$category")

# Crypto
category="Crypto Tools and Libraries"
## Sodium
tools_name+=("Sodium")
tools_command_getStatus+=("dpkg -s libsodium-dev")
tools_command_install+=("sudo apt-get -y install libsodium-dev")
tools_command_postinstall+=("")
tools_category+=("$category")
## OpenSSL
tools_name+=("OpenSSL")
tools_command_getStatus+=("dpkg -s openssl libssl-dev")
tools_command_install+=("sudo apt-get -y install openssl libssl-dev")
tools_command_postinstall+=("")
tools_category+=("$category")
## Crypto++
tools_name+=("Crypto++")
tools_command_getStatus+=("dpkg -s $(apt-cache pkgnames | grep -i libcrypto++)")
tools_command_install+=("sudo apt-get -y install $(apt-cache pkgnames | grep -i libcrypto++)")
tools_command_postinstall+=("")
tools_category+=("$category")
