#!/usr/bin/env bash
# Copyright 2017 Yash D. Saraf
# This file is part of BB-Bot.

# BB-Bot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# BB-Bot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with BB-Bot.  If not, see <http://www.gnu.org/licenses/>.

set -e
STATUS="Stable"
DATE="`date +'%d %b/%y'`"
export STATUS DATE
CURRDIR=$PWD
cd "`dirname $0`"
if [[ ! -d ../busybox ]]
	then (cd .. && git clone https://github.com/yashdsaraf/busybox.git)
else
	cd ../busybox
	git pull
	cd "`dirname $0`"
fi
echo -e "\n\nStarting BB-Bot build v${VER}-${TRAVIS_BUILD_NUMBER} ${TO_BUILD}\n\n"
. ./toolchain-exports.sh
if [[ $TO_BUILD == "boxemup" ]]
	then
	mkdir -p ../out
	cd ../out
	java -jar $TOOLCHAINDIR/BoxIO-1.0.0.jar ../credentials.properties LISTEN 17
	cd ../scripts
	./update-bins.sh
	./createtgz.sh
	./mkzip.sh
	cd ../bbx/out
	DIR=`date +'%b-%d-%y'`
	mkdir -p $DIR/Tars
	cd $DIR/Tars
	mv ../../../Bins/*tar.gz .
	cd ..
	mv ../*zip .
else
	./build-ssl.sh
	./build-bb.sh
	cd ../out
	java -jar $TOOLCHAINDIR/BoxIO-1.0.0.jar ../credentials.properties UPLOAD *
fi
cd $CURRDIR
