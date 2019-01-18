#!/usr/bin/env bash
#  ____  _  _  ____  ____   ___  ____  __  ____  ____
# / ___)/ )( \(  _ \/ ___) / __)(  _ \(  )(  _ \(  __)
# \___ \) \/ ( ) _ (\___ \( (__  )   / )(  ) _ ( ) _)
# (____/\____/(____/(____/ \___)(__\_)(__)(____/(____).sh
#
# Usage
#
#	./subscribe.sh -u USERNAME -p PASSWORD -n COMPUTER-NAME
#
# This script will:
# - Register the system with your Red Hat Developer account
# - Install the latest updates
#
# You will be prompted for your developer account credentials.
#
# If you are running this at DORIS, make sure your proxy is set.
# See /etc/profile.d/proxy.sh

# VARIABLES
RHEL_6="6."
RHEL_7="7."
username=""
password=""
computer_name=""

usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -u, --username <username>         Usernamen for authenticating to RHSN
  -p, --password <password>         Password for authenticating to RHSN
  -n, --name <name>                 Computer name for RHSN
  -h, --help                        Print out this help text
EOF
}

set_variable() {
	local varname=$1
	shift
	if [ -z "${!varname}" ]; then
		# shellcheck disable=SC2145
		eval "$varname=\"$@\""
	else
		echo "Error: $varname already set"
		exit 1
	fi
}

while getopts 'upn:?h' opt; do
	case $opt in
	u) set_variable username "$OPTARG" ;;
	p) set_variable password "$OPTARG" ;;
	n) set_variable computer_name "$OPTARG" ;;
	h | ?) usage ;;
	esac
done

username=${username:-USERNAME}
password=${password:-USERNAME}
computer_name=${computer_name:-COMPUTER_NAME}

# ensure running as root
if [ "$(id -u)" != "0" ]; then
	exec sudo "$0" "$@"
fi

subscription-manager register --username "$username" --password "$password" --name "$computer_name" --auto-attach --force
subscription-manager attach

# shellcheck disable=SC2154 # This is checking to see if http_proxy is not null
if [ -n "$http_proxy" ]; then
	proxy_hostname=${proxy_hostname-""}
	proxy_port=${proxy_port-""}
	sudo subscription-manager config --server.proxy_hostname="$proxy_hostname" --server.proxy_port="$proxy_port"
fi

if grep -q $RHEL_7 /etc/redhat-release; then
	subscription-manager repos --enable rhel-server-rhscl-7-rpms
	subscription-manager repos --enable rhel-7-server-optional-rpms
elif grep -q $RHEL_6 /etc/redhat-release; then
	subscription-manager repos --enable rhel-server-rhscl-6-rpms
	subscription-manager repos --enable rhel-6-server-optional-rpms
fi

yum -y update

printf "\nPlease reboot now:\n\n"
printf "\t$ exit\n"
printf "\t$ vagrant reload\n\n"
