#!/usr/bin/env bash
# Com is a wrapper around other command-line utilities.

name=$(basename $0)

echo got args: $@
echo running...

help() {
	cat <<-EOF
	Com is a wrapper around other command-line utilities.

	Usage:

	${name} command [arg, ...]

	Examples:

	com help
	com version
	com ansible-playbook ping.yml
	com ansible --help
	com ansible -i localhost, -c local all -m ping
	com vault help
	com vault kv list secret
	EOF
}

if [[ $1 == "" ]]
then
	echo ${name}: argument error: command is required!
	help
	exit 1
elif [[
	$1 == "-h"
	|| $1 == "--help"
	|| $1 == "help"
]]
then
	help
	exit 0
elif [[ 
	$1 == "version"
	|| $1 == "-V"
	|| $1 == "--version"
]]
then
	cat /VERSION
	exit 0
elif [[ $1 == "ansible-playbook" ]]
then
	echo you picked the ansible-playbook command!
	echo doing something before running ansible
	echo doing something else before running ansible
	echo doing yet another thing before running ansible
	echo now running ansible, but first shift args!
	echo args now: $@
	shift
	echo args now: $@
	additional_args=""
	if [[ $1 == "ping.yml" ]]
	then
		additional_args="-i localhost, -c local"
	fi
	ansible-playbook $additional_args $@
elif [[ $1 == "ansible" ]]
then
	shift
	additional_args=""
	ansible $additional_args $@
elif [[ $1 == "vault" ]]
then
	echo start vault dev server
	vault server -dev -address=0.0.0.0:8200 &>> /var/log/vault.log &
	sleep 1
	echo discover root token
	export VAULT_DEV_ROOT_TOKEN_ID=$(awk '/Root Token:/ { print $NF }' <<< /var/log/vault.log)
	echo set some more environment variables
	export VAULT_ADDR=http://127.0.0.1:8200
	echo load some example secret
	vault kv put secret/hello foo=world bar=cats baz=dogs
	echo now running vault, but first shift args!
	echo args now: $@
	shift
	echo args now: $@
	additional_args=""
	vault $additional_args $@
else
	$@
fi
