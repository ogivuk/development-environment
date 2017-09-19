# This script file contains supporting functions for automatized installation process
# This script file is not meant to be used alone.
#
# Author Name: Ognjen Vukovic
# Author Email: ognjen.m.vukovic@gmail.com
# Date: Sept 2017
#

# Colors
#https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
COLOR_DONE='\033[0;32m' #Green
COLOR_FAILED='\033[0;31m' #Red
COLOR_DOING='\033[1;33m' #Yellow
COLOR_INSTALLED='\033[0;34m' #Blue
COLOR_INSTALL='\033[0;32m' #Green
COLOR_SKIP='\033[0;31m' #Red
COLOR_NONE='\033[0m' #No color

function init()
{
	# Performs any initialization tasks
	# Promt user for sudo password, if needed
	sudo echo >/dev/null
	# Update repository
    echo -ne "${COLOR_DOING}[DOING]${COLOR_NONE} Updating repositories...\r"
	sudo apt-get -qq update #&& sudo apt-get -q upgrade
	if [ $? == 0 ]
	then
	    echo -e "${COLOR_DONE}[DONE]${COLOR_NONE} Updating repositories."
	else
		echo -e "${COLOR_FAILED}[FAILED]${COLOR_NONE} Updating repositories."
	fi
}
function alreadyInstalled()
{
	# Checks if the package is already installed
	# $1 is the package name
	eval dpkg -s $1 1>/dev/null 2>&1
	if [ $? == 0 ]
	then # it is installed
		return 0 #signal for OK
	else # it is not installed
		return 1 #signal for Not OK
	fi
}
function alreadyInstalledPackage()
{
	# Checks if the package is already installed
	# $1 is the package name
	eval dpkg -s $1 1>/dev/null 2>&1
	if [ $? == 0 ]
	then # it is installed
		return 0 #signal for OK
	else # it is not installed
		return 1 #signal for Not OK
	fi
}
function alreadyInstalledModule()
{
	# Checks if the package is already installed
	# $1 is the package name
	eval dpkg -s $1 1>/dev/null 2>&1
	if [ $? == 0 ]
	then # it is installed
		return 0 #signal for OK
	else # it is not installed
		return 1 #signal for Not OK
	fi
}
function installFromRepo()
{
	# Installs the package from the repository
	#$1 is the software name, used for user-friendly output
	#$2 is the package name, used by the repository
	echo -ne "${COLOR_DOING}[DOING]${COLOR_NONE} Installing" $1"...\r"
	sudo apt-get -y install $2 1>/dev/null
	if [ $? == 0 ]
	then
	    echo -e "${COLOR_DONE}[DONE]${COLOR_NONE} Installing" $1"."
	else
		echo -e "${COLOR_FAILED}[FAILED]${COLOR_NONE} Installing" $1"."
	fi
}
function addRepo()
{
	# Adds a new repository to the list
	#$1 is the package name, used for naming the source list
	#$2 is the repo name and attribute, used to add the repo to the list
	#$3 is the key URL, used to download the key
	if [ "$(lsb_release -i | cut -f 2)" == "Ubuntu" ] || [ "$(lsb_release -i | cut -f 2)" == "Debian" ]; then
		echo "deb" $2 | sudo tee /etc/apt/sources.list.d/$1.list 1>/dev/null
		wget -qO - $3 | sudo apt-key add - 1>/dev/null
		sudo apt-get update 1>/dev/null
	fi
}
function installTool()
{
	# Installs the tool based on the command
	#$1 is the tool name, used for user-friendly output
	#$2 is the install command
	echo -ne "${COLOR_DOING}[DOING]${COLOR_NONE} Installing" $1"...\r"
	eval $2 1>/dev/null
	if [ $? == 0 ]
	then
	    echo -e "${COLOR_DONE}[DONE]${COLOR_NONE} Installing" $1"."
	else
		echo -e "${COLOR_FAILED}[FAILED]${COLOR_NONE} Installing" $1"."
	fi
}
function displayInstallMenu()
{   
    clear
    # Print the menu with the packages
    currentCategory=""
    for i in ${!tools_name[@]}; do
        # Print category
        if [ "$currentCategory" != "${tools_category[$i]}" ];then
            echo "#" ${tools_category[$i]} "#"
            currentCategory=${tools_category[$i]}
        fi
        # Print based on the install status. Format: ordNum status name
        case ${tools_installStatus[$i]} in
            0) # Already installed
                printf "%2d) ${COLOR_INSTALLED}%9s${COLOR_NONE} %s\n" $((i+1)) "[OK]" "${tools_name[$i]}"
                ;;
            1) # To be installed
                printf "%2d) ${COLOR_INSTALL}%9s${COLOR_NONE} %s\n" $((i+1)) "[INSTALL]" "${tools_name[$i]}"
                ;;
            2) # To be skipped
                printf "%2d) ${COLOR_SKIP}%9s${COLOR_NONE} %s\n" $((i+1)) "[SKIP]" "${tools_name[$i]}"
                ;;
        esac
    done
    echo ""
    if [ "$1" != "" ]; then
        echo $1 && echo ""
    fi
}