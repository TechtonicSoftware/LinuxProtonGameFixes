#!/bin/bash

REQBINS=("wine" "winetricks" "sed");

APPNAME="Fallout 4";
APPID="377160";
WINEDIR="$(pwd)/$APPID/pfx";
FALLOUT4INI="$WINEDIR/drive_c/users/steamuser/My Documents/My Games/Fallout4/Fallout4.ini";
FALLOUT4INIBAK="$FALLOUT4INI.bak";
FALLOUT4PREFSINI="$WINEDIR/drive_c/users/steamuser/My Documents/My Games/Fallout4/Fallout4Prefs.ini";
FALLOUT4PREFSINIBAK="$FALLOUT4PREFSINI.bak";

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

#Backup INI File/s
if [ ! -f "$FALLOUT4INIBAK" ]; then
        echo -e "Backing up original ini file..\n";
        cp "$FALLOUT4INI" "$FALLOUT4INIBAK";
fi
if [ ! -f "$FALLOUT4PREFSINIBAK" ]; then
        echo -e "Backing up original prefs ini file..\n";
        cp "$FALLOUT4PREFSINI" "$FALLOUT4PREFSINIBAK";
fi

echo -e "Adding fixes to config file/s..\n";

#Apply Mouse Fix To Config File
sed -i '/bBackgroundMouse/d' "$FALLOUT4INI";
sed -i '/\[Controls\]/a bBackgroundMouse=1' "$FALLOUT4INI";

#Apply lighting fix
sed -i 's/bComputeShaderDeferredTiledLighting=1/bComputeShaderDeferredTiledLighting=0/g' "$FALLOUT4PREFSINI";

#Tell User they must now add launch option (will maybe add edit for localconfig.vdf later)
echo -e "All done! You must now add the following to $APPNAME's launch options (located under $APPNAME,Properties,General,Set Launch Options) to fix any sound issues:\n";
echo -e 'WINEDLLOVERRIDES="xaudio2_7=n,b" PULSE_LATENCY_MSEC=90 %command%';