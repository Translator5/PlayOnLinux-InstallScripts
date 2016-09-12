#!/bin/bash
# Date : (2012-04-15 18-02)
# Last revision : (2013-07-02 23-16)
# Wine version used : 1.4-dos_support_0.6
# Distribution used to test : Debian Sid (Unstable)
# Author : Pierre Etchemaite pe-pol@concept-micro.com
# Script licence : GPL v.2
# Program licence : Retail
# Depend :
 
[ -z "$PLAYONLINUX" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
PREFIX="ElderScrolls_Daggerfall"
WORKING_WINE_VERSION="1.4-dos_support_0.6"
 
TITLE="The Elder Scrolls II: Daggerfall"
SHORTCUT_NAME="The Elder Scrolls II: Daggerfall"
 
POL_GetSetupImages "http://files.playonlinux.com/resources/setups/$PREFIX/top.jpg" "http://files.playonlinux.com/resources/setups/$PREFIX/left.jpg" "$TITLE"
 
POL_SetupWindow_Init
POL_SetupWindow_SetID 1129
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "Bethesda Softworks" "http://www.elderscrolls.com/daggerfall/" "Pierre Etchemaite" "$PREFIX"
 
if [ -n "$POL_SELECTED_FILE" ]; then
        ARCHIVE="$POL_SELECTED_FILE"
else
        cd "$POL_USER_ROOT/tmp"
        cat <<_EOFTOU_ > daggerfall_tou.txt
IMPORTANT - PLEASE READ CAREFULLY BEFORE INSTALLING THE ELDER SCROLLS II: DAGGERFALL™ ("THIS PRODUCT").
 
THIS IS A LEGAL DOCUMENT STATING THE TERMS AND CONDITIONS GOVERNING INSTALLATION AND USE OF THIS PRODUCT. BY INSTALLING OR USING THIS PRODUCT, YOU AGREE TO THE TERMS STATED HEREIN BY BETHESDA SOFTWORKS.
 
IF YOU DO NOT AGREE, DO NOT INSTALL.
 
1. You have a non-exclusive, non-transferable license and right to use this Product for your own personal use and enjoyment. This Product is not provided for any non-personal, commercial purpose. All rights not expressly granted to you herein are hereby reserved by Bethesda Softworks.
 
2. As between you and Bethesda Softworks, all rights, title and interest in and to the Product, and all worldwide intellectual property rights that are embodied in, related to, or represented by the Product, are and at all times shall remain the sole and exclusive property of Bethesda Softworks.
 
3. This Product is provided "as is." Bethesda Softworks makes no representation, warranty or covenant of any kind as to merchantability or fitness for a particular purpose or use, and disclaims any liability with respect thereto. In no event shall Bethesda Softworks, its affiliates, or their respective officers, directors, employees or agents be liable in any way to you or to any third party for any damage whatsoever that may result from use of this Product or its installation.
 
4. Neither Bethesda Softworks nor any of its affiliates will provide any technical or customer support with respect to this Product or its use by you or any third party.
 
5. You acknowledge that Bethesda Softworks owns any and all trademark, copyright and other proprietary rights to this Product.
_EOFTOU_
        POL_SetupWindow_licence "Terms of Use of Daggerfall" "$TITLE" "$POL_USER_ROOT/tmp/daggerfall_tou.txt"
 
        POL_Download "http://dl2.hwupgrade.it/dl/7b0fe63e3676efa29f5bd7b9f2f36704/55a699dc/videogiochi/demo/DFInstall.zip" "3cdd09a5696c2b94c58b85488be7cba2"
fi
 
cd "$POL_USER_ROOT/tmp"
 
POL_Download "http://theelderscrolls.wiwiland.net/Fichiers/DaggerfallManuel.pdf" "423efeebc9adfbddf5b8bd7e566d1eac"
 
POL_Download "http://files.playonlinux.com/unpk.py" "0e358342663c933eb7e49bb11d0ab1f2"
 
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
 
POL_SetupWindow_wait "$(eval_gettext 'Decompressing archive...')" "$TITLE"
 
cd "$WINEPREFIX/drive_c"
unzip "$POL_USER_ROOT/tmp/DFInstall.zip"
 
POL_SetupWindow_wait "$(eval_gettext 'Please wait while $TITLE is installed.')" "$TITLE"
 
function unpk()
{
        POL_SetupWindow_pulsebar "$(eval_gettext 'Decompressing archive...')" "$TITLE"
        python -u "$POL_USER_ROOT/tmp/unpk.py" "$@" | \
        while read line; do
                case "$line" in
                        "Extracting file "*)
                                POL_SetupWindow_set_text "$line"
                                POL_SetupWindow_pulse 0
                                ;;
                        *" %")
                                POL_SetupWindow_pulse "${line% %}"
                        ;;
                esac
        done
}
 
# Simulate minimum install
cp DFCD/INSTALL.EXE DFCD/INSTALL.SCR DFCD/INSTALL.PIF DAGGER/
cp DFCD/DAGGER/* DAGGER/
mkdir DAGGER/SAVE{0,1,2,3,4,5}
mkdir DAGGER/DATA
cp DFCD/DATA/* DAGGER/DATA/
mkdir DAGGER/ARENA2
cp DFCD/DAGGER/ARENA2/REPORT.EXE DAGGER/ARENA2/
cp DFCD/DAGGER/ARENA2/TEXT.RSC DAGGER/ARENA2/
mkdir DAGGER/ARENA2/MAPS
cp DFCD/DAGGER/ARENA2/MAPS/MAPSAVE.SAV DAGGER/ARENA2/MAPS/
unpk DFCD/DAGGER/ARENA2/PACKED.DAT DAGGER/
# offset of the end of "start of data" string in the file
unpk DAGGER/DAG213.EXE DAGGER/ 61277
 
# simulate the rest of DAG213.EXE work: patching MAPS.BSA
cp DFCD/DAGGER/ARENA2/MAPS.BSA DAGGER/ARENA2/
FILE=DAGGER/ARENA2/MAPS.BSA
cpatch() {
        string="$1"
        shift
        for offset in "$@"; do
                printf "$string\\0"|dd of=$FILE conv=notrunc bs=1 seek=$offset
        done
}
cpatch "Hal's Tavern" 1047962 1483930 3822533 5168320 11861871 12007237 18182800 18226618 19076460 19558619 19694830 20135365
cpatch "Chris's Inn" 1184610 1487514
cpatch " Heights" 6286605 7318532
# Expected MD5 hash 7121927d200ea03e5d833ae188a13cfa
 
cat <<'_EOFCFG_' | perl -pe 's/\n/\r\n/' > DAGGER/Z.CFG
type dfall_minimum
path c:\dagger\arena2\
pathcd w:\dagger\arena2\
fadecolor 0
mapfile d
rendergame 1
user 1
startMap 179
region 17
helmet 0
maxSpeed 200
controls betaplyr.dat
maps mapsave.sav
_EOFCFG_
 
cat <<'_EOFSND_' | perl -pe 's/\n/\r\n/' > DAGGER/HMISET.CFG
 
[DIGITAL]
DeviceName  = Sound Blaster 16/AWE32   
DeviceIRQ   = 5
DeviceDMA   = 1
DevicePort  = 0x220
DeviceID    = 0xe016
 
[MIDI]
DeviceName  = Sound Blaster 16         
DevicePort  = 0x388
DeviceID    = 0xa009
 
_EOFSND_
 
cat <<'_EOFCFG_' >> "$WINEPREFIX/playonlinux_dos.cfg"
render_aspect=true
dosbox_memsize=32
cpu_cycles='max 95% limit 33000'
manual_mount=true
_EOFCFG_
[ "$POL_OS" = "Linux" ] && echo "render_scaler=hq2x" >> "$WINEPREFIX/playonlinux_dos.cfg"
 
cat <<_EOFBAT_ > "$WINEPREFIX/drive_c/autoexec.bat"
mount W "$WINEPREFIX/drive_c/DFCD" -t cdrom -label Daggerfall
_EOFBAT_
 
cp "$POL_USER_ROOT/tmp/DaggerfallManuel.pdf" "$WINEPREFIX/drive_c/DAGGER/"
 
POL_Wine_WaitExit "$TITLE"
 
 
# Icon from KingReverant http://kingreverant.deviantart.com/art/The-Elder-Scrolls-series-icons-161685128
POL_Shortcut "DAGGER/DAGGER.EXE" "$SHORTCUT_NAME" "$SHORTCUT_NAME.png" "" "Game;RolePlaying;"
POL_Shortcut_Document "$SHORTCUT_NAME" "$WINEPREFIX/drive_c/DAGGER/DaggerfallManuel.pdf"
 
POL_SetupWindow_Close
 
exit 0
