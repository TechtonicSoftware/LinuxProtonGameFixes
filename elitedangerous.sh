#!/bin/bash

REQBINS=("wine" "winetricks");

APPNAME="Elite Dangerous";
APPID="359320";
WINEDIR="$(pwd)/$APPID/pfx";

#Check binaries actually exist
for bin in "${REQBINS[@]}"; do
        if ! $(hash $bin 2>/dev/null); then
                echo "Missing required executable ($bin)! Please ensure the application is installed.";
                exit 1;
        fi
done

if [ ! -d $WINEDIR ]; then
	echo -e "Cannot find $APPNAME wine prefix directory!\nEnsure this script is inside your steam library compatdata folder and that you have run the application at least once.";
	exit 1;
fi


#Remove old wine directory and create new one
if [ -d $WINEDIR ]; then
	rm -R $WINEDIR;
fi
WINEPREFIX=$WINEDIR winetricks -q dotnet40 win7
