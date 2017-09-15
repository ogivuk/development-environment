#!/bin/bash

source functions.sh

# Prepare for installations
init

# Google Performance Tools
if alreadyInstalled "google-perftools"
then
	echo "[OK] Google Performance Tools already installed."
else
	installFromRepo "Google Performance Tools" "google-perftools libgoogle-perftools-dev"
fi

# Google Test Tools
if alreadyInstalled google-mock
then
	echo "[OK] Google Mock and Test already installed."
else
	echo "Installing Google Mock and Test…"
	installFromRepo "Google Mock and Test" "google-mock libgtest-dev"
	echo "Building Google Mock and Test..."
	cd /usr/src/gtest
	sudo cmake -E make_directory build
	sudo cmake -E chdir build cmake .. 1>> /dev/null
	sudo cmake --build build 1>> /dev/null
	sudo cp build/libgtest* /usr/local/lib/
	sudo rm -rf build
	echo "[DONE] Building Google Mock and Test."
fi

# ReText - A Simple Markdown Text Editor and Viewer
if alreadyInstalled retext
then
	echo "[OK] ReText already installed."
else
	installFromRepo "ReText" "retext"
fi