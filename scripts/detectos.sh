#!/usr/bin/env bash

[[ $DEBUG = 'true' ]] && set -x

if [[ -f /usr/bin/python2 ]];
then
    echo "python2 already present"
else
    echo "installing python2"
    OS=$(awk -F= '/\<ID\>/ {print $2}' /etc/os-release)
    if [[ "$OS" = "fedora" ]]
    then
        dnf install -y python2
    elif [[ "$OS" = "ubuntu" ]] || [[ "$OS" = "debian" ]]
    then
        sudo apt-get install -y python2
    elif [[ "$OS" = "centos" ]]
    then
         yum install -y python2
    else
        echo "unknown OS"
    fi

    if [[ ! -f /usr/bin/python ]]
    then
        ln -s /usr/bin/python2 /usr/bin/python
    fi
fi
