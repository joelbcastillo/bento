#!/usr/bin/env bash
#  _  _  __ _  ____  _  _  ____  ____   ___  ____  __  ____  ____
# / )( \(  ( \/ ___)/ )( \(  _ \/ ___) / __)(  _ \(  )(  _ \(  __)
# ) \/ (/    /\___ \) \/ ( ) _ (\___ \( (__  )   / )(  ) _ ( ) _)
# \____/\_)__)(____/\____/(____/(____/ \___)(__\_)(__)(____/(____).sh
#
# Usage
#
#	./unsubscribe.sh
#
# This script will:
# - Register the system with your Red Hat Developer account
# - Install the latest updates
#
# You will be prompted for your developer account credentials.
#
# If you are running this at DORIS, make sure your proxy is set.
# See /etc/profile.d/proxy.sh
#
subscription-manager unsubscribe --all || true
subscription-manager unregister || true
