#!/usr/bin/env bash
# Copyright 2016 Yash D. Saraf
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

EXTRA=
i=`cut -d' ' -f1 <<< $TO_BUILD`
CURRDIR=$PWD
cd "`dirname $0`/../bbx"
echo $i
echo "======================================================"
cd Bins/$i
( rm busybox*
rm ssl_helper ) 2>/dev/null
cp -v ../../../out/ssl_helper-$i ssl_helper
if [[ $i != "mipseb" ]]
then
	cat > "bins.md5" <<EOF
$(md5sum ssl_helper)
$(md5sum xzdec)
EOF
fi
for f in $(ls ../../../out/busybox-${i}{64,_64,}-*)
do
	[[ $f =~ "nosel" ]] || EXTRA="-sel"
	[[ $f =~ "64" ]] && EXTRA="64$EXTRA"
	cp -v $f "busybox$EXTRA"
	xz -eq9 "busybox$EXTRA"
	rm "busybox$EXTRA" 2>/dev/null
	[[ $i != "mipseb" ]] &&
	echo "$(md5sum busybox$EXTRA.xz)" >> "bins.md5"
	EXTRA=
done 2>/dev/null
cp ../../../out/ssl_helper-$i ssl_helper 2>/dev/null
echo "======================================================"
echo ""
# [[ $i != "mipseb" ]] && sed -i "s/  /=/g" bins.md5
cd $CURRDIR
