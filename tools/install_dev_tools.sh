#!/bin/bash
 
##
# Multi-select menu in bash script
#
# bash-only code that does exactly what you want. It's short (~20 lines), but a
# bit cryptic for a begginner. Besides showing "+" for checked options, it also
# provides feedback for each user action ("invalid option", "option X was
# checked"/unchecked, etc). -- http://serverfault.com/a/298312
##

source functions.sh

function displayInstallMenu()
{
    clear
    # Print the menu with the packages
    currentCategory=""
    for i in ${!tools_names[@]}; do
        # Print category
        if [ "$currentCategory" != "${tools_category[$i]}" ];then
            if [ "$currentCategory" != "" ];then
              echo ""
            fi
            echo "#" ${tools_category[$i]} "#"
            currentCategory=${tools_category[$i]}
        fi
        # Print the tools: ordNum status name
        printf "%2d) %9s %s\n" $((i+1)) "[${tools_status[$i]}]" "${tools_names[$i]}"
    done
    echo ""
    if [ "$1" != "" ]
    then
        echo $1
        echo ""
    fi
}

function getUserInput()
{
    read -rp "Change status of an option (INSTALL->SKIP or SKIP->INSTALL), ENTER when done: " $1
}

function checkIfInstalled()
{
    # Check if the packages are already installed, if not set to INSTALL
    for i in ${!tools_packages[@]}; do
        if alreadyInstalled $tools_packages[$i];then
            tools_status[$i]="OK"
        else
            tools_status[$i]="INSTALL"
        fi
    done
}

tools_names=()
tools_packages=()
tools_category=()

# Editors
category="Editors"
## VS Code
tools_names+=("VS Code")
tools_packages+=("code")
tools_category+=("$category")

## Sublime
tools_names+=("Sublime")
tools_packages+=("sublime-text")
tools_category+=("$category")

## ReText
tools_names+=("ReText")
tools_packages+=("retext")
tools_category+=("$category")

# Version Control
category="Version Control Tools"
## Git
tools_names+=("Git")
tools_packages+=("git")
tools_category+=("$category")

# Languages and Compliers
category="Languages and Compliers"
## Python2
tools_names+=("Python2")
tools_packages+=("python")
tools_category+=("$category")

## Python3
tools_names+=("Python3")
tools_packages+=("python3")
tools_category+=("$category")

## Python3-Pip
tools_names+=("Python3-Pip")
tools_packages+=("python3-pip")
tools_category+=("$category")

## G++
tools_names+=("G++")
tools_packages+=("g++")
tools_category+=("$category")

## CMake
tools_names+=("CMake")
tools_packages+=("cmake")
tools_category+=("$category")

# Web Browsers
category="Web Browsers"
## Google Chrome
tools_names+=("Google Chrome")
tools_packages+=("google-chrome-stable")
tools_category+=("$category")

tools_names+=("Firefox")
tools_packages+=("firefox")
tools_category+=("$category")

# Web Development
category="Web Development"
## Django
tools_names+=("Django")
tools_packages+=("django")
tools_category+=("$category")

## Selenium
tools_names+=("Selenium")
tools_packages+=("selenium")
tools_category+=("$category")

# Testing
category="Testing Tools"
## Google Test Tools
tools_names+=("Google Mock and Test Tools")
tools_packages+=("google-mock")
tools_category+=("$category")

# Peformance Optimizers
category="Performance Optimizers"
## Google Performance Tools
tools_names+=("Google Performance Tools")
tools_packages+=("google-perftools")
tools_category+=("$category")

# Crypto
category="Crypto Tools and Libraries"
## Sodium
tools_names+=("Sodium")
tools_packages+=("libsodium-dev")
tools_category+=("$category")
## OpenSSL
tools_names+=("OpenSSL")
tools_packages+=("openssl libssl-dev")
tools_category+=("$category")
## Crypto++
tools_names+=("Crypto++")
tools_packages+=("libcrypto++-dev")
tools_category+=("$category")

checkIfInstalled

selection=0
menuMsg=""

while displayInstallMenu "$menuMsg" && getUserInput selection && [[ "$selection" ]]
do
    if (( selection > 0 && selection <= ${#tools_names[@]} ));then
        case "${tools_status[$selection-1]}" in
            INSTALL)
                tools_status[$selection-1]="SKIP"
                menuMsg="${tools_names[$selection-1]} will NOT be installed."
                ;;
            SKIP)
                tools_status[$selection-1]="INSTALL"
                menuMsg="${tools_names[$selection-1]} will be installed."
                ;;
            OK)
                menuMsg="${tools_names[$selection-1]} is already installed."
                ;;
            *)
                echo "[ERROR 1] Something went wrong."
                exit 1
                ;;
        esac
    else
        menuMsg="Invalid option: $selection"
    fi
done

#printf "Tools to be installed"
#printf "You selected"; msg=" nothing"
#for i in ${!options[@]}; do
#    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
#done
#echo "$msg"