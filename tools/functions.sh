# Functions
function init()
{
	# Performs any initialization tasks
    echo -ne "Updating repositories...\r"
	sudo apt-get -qq update #&& sudo apt-get -q upgrade
    echo "[DONE] Updating repositories."
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
function installFromRepo()
{
	# Installs the package from the repository
	#$1 is the software name, used for user-friendly output
	#$2 is the package name, used by the repository
	echo -ne "Installing" $1"...\r"
	sudo apt-get -y install $2 1>/dev/null
	if [ $? == 0 ]
	then
	    echo "[DONE] Installing" $1"."
	else
		echo "[FAILED] Installing" $1"."
	fi
}
function addRepo()
{
	# Adds a new repository to the list
	#$1 is the package name, used for naming the source list
	#$2 is the repo name and attribute, used to add the repo to the list
	#$3 is the key URL, used to download the key
	echo "deb" $2 | sudo tee /etc/apt/sources.list.d/$1.list
	wget -qO - $3 | sudo apt-key add -
	sudo apt-get -qq update
}