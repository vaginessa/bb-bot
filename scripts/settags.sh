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

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"

if -z $TRAVIS_TAG && ! (git ls-remote --tags | grep -wq $BUILD_TAG) &>/dev/null
	then
	echo -e "Starting to tag commit.\n"
	git tag -a $BUILD_TAG -m "Travis build $TRAVIS_BUILD_NUMBER pushed a tag."
	git push origin --tags
	echo -e "Done tagging this build.\n"
fi

git fetch origin