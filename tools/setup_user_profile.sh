#!/bin/bash

source functions.sh

tools_name=()
tools_category=()
tools_command_status=()
tools_command_install=()
tools_command_postinstall=()

# User Profile
category="User Profile"
## Background Image
tools_name+=("Background Image: Night Lights")
tools_command_getStatus+=('gsettings get org.gnome.desktop.background picture-uri | grep "file:////usr/share/backgrounds/Night_lights_by_Alberto_Salvia_Novella.jpg" >/dev/null')
tools_command_install+=("gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/Night_lights_by_Alberto_Salvia_Novella.jpg")
tools_command_postinstall+=("")
tools_category+=("$category")
## Multiple Workspaces
tools_name+=("Multiple Workspaces (System Settings -> Personal -> Appearance -> Behavior -> Enable Workspaces)")
tools_command_getStatus+=("")
#gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize [x]
#gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize [y]
tools_command_install+=('
	echo "To enable multiple workspaces go to:"
	echo "System Settings -> Personal -> Appearance -> Behavior -> Enable Workspaces"
	read -p "Press Enter to continue with the rest." userInput
	')
tools_command_postinstall+=("")
tools_category+=("$category")

# configure shared VB folder access, if such exists
if grep -q vboxsf /etc/group; then
	tools_name+=("VB Folder Access Right")
	tools_command_getStatus+=('! id -nG "$USER" | grep -qw "vboxsf')
	tools_command_install+=("sudo adduser $USER vboxsf")
	tools_command_postinstall+=("")
	tools_category+=("$category")
fi

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
echo "---------------------------------------"
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
echo "---------------------------------------"