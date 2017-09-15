#!/bin/bash

source functions.sh

# Prepare for installations
init

# Sodium
if alreadyInstalled "libsodium-dev"
then
	echo "[OK] Sodium already installed."
else
	installFromRepo "Sodium" "libsodium-dev"
fi

# OpenSSL
if alreadyInstalled "openssl libssl-dev"
then
	echo "[OK] OpenSSL (Dev) already installed."
else
	installFromRepo "OpenSSL (Dev)" "openssl libssl-dev"
fi

# Crypto++
if alreadyInstalled "libcrypto++-dev"
then
	echo "[OK] Crypto++ already installed."
else
	installFromRepo "Crypto++" "libcrypto++-dev"
fi