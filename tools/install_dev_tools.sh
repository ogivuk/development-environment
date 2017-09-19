#!/bin/bash
# This script automates installation process of the tools specified in 'list_of_tools.sh' list
# All tools will be installed by default, but user can select to skip any installation
#
# Author Name: Ognjen Vukovic
# Author Email: ognjen.m.vukovic@gmail.com
# Date: Sept 2017
#

source functions.sh

tools_name=()
tools_category=()
tools_command_status=()
tools_command_install=()
tools_command_postinstall=()

source list_of_tools.sh

# check if the tools are already installed, update their installStatus accordingly
for i in ${!tools_command_getStatus[@]}; do
    #(${tools_command_getStatus[$i]} 1>/dev/null 2>&1)
    eval ${tools_command_getStatus[$i]} 1>/dev/null 2>&1
    if [ $? == 0 ]
    then # it is installed
        tools_installStatus[$i]=0
    else # it is not installed
        tools_installStatus[$i]=1
    fi
done

# Display menu and capture user input. Terminate on ENTER
menuMsg=""
promt_msg="Change status of an option (INSTALL->SKIP or SKIP->INSTALL), ENTER when done: "
while displayInstallMenu "$menuMsg" && read -rp "$promt_msg" selection && [[ "$selection" ]]
do
    if (( selection > 0 && selection <= ${#tools_name[@]} ));then
        case "${tools_installStatus[$selection-1]}" in
            0) #already installed
                menuMsg="${tools_name[$selection-1]} is already installed."
                ;;
            1) #install
                tools_installStatus[$selection-1]=2 #set to skip
                menuMsg="${tools_name[$selection-1]} will NOT be installed."
                ;;
            2) #skip
                tools_installStatus[$selection-1]=1 #set to install
                menuMsg="${tools_name[$selection-1]} will be installed."
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

# Perform the installation & post installation
echo "Preparing for installation:"
init
echo "Installation:"
finalMsg="Nothing to do."

for i in ${!tools_name[@]}; do
    # Check if this one should be installed
    if [ ${tools_installStatus[$i]} = 1 ];then
        # Run the install
        installTool "${tools_name[$i]}" "${tools_command_install[$i]}"
        eval "${tools_command_postinstall[$i]}"
        finalMsg="Installations Completed."
    fi
done

echo $finalMsg