#!/usr/bin/env bash

if [[ $TO_BUILD == "boxemup" ]]
	then
	sudo apt-get update -qq
	sudo apt-get install -qq p7zip-full realpath
else
	sudo add-apt-repository ppa:jonathonf/automake
	sudo apt-get update -qq
	sudo apt-get install -qq automake-1.15
fi

