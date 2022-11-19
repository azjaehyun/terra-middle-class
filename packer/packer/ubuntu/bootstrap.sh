#!/bin/bash
set -ex

function redhatPackageManager {
    sudo yum install -y epel-release
    sudo yum install -y ansible
}

function ubuntuPackageManager {
    sudo add-apt-repository universe
    sudo apt-get update
    sudo apt-get install -y ansible
#    sudo apt -y install software-properties-common
}

if  [[ -x "$(command -v yum)" ]]; then
    redhatPackageManager
fi

if  [[ -x "$(command -v apt-get)" ]]; then
    ubuntuPackageManager
fi