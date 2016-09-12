#!/bin/bash
# Date : (2016-09-12 15-35)
# Wine version used : 1.6.2-dos_support_0.6
# Distribution used to test : Linux Mint 18 x64
# Script licence : GPL v.2
# Author : Pierre Etchemaite pe-pol@concept-micro.com 

[ -z "$PLAYONLINUX" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
PREFIX="ElderScrolls_Arena"
WORKING_WINE_VERSION="1.6.2-dos_support_0.6"
TITLE="The Elder Scrolls I: Arena"
SHORTCUT_NAME="The Elder Scrolls I: Arena"
 
POL_GetSetupImages "http://files.playonlinux.com/resources/setups/$PREFIX/top.jpg" "http://files.playonlinux.com/resources/setups/$PREFIX/left.jpg" "$TITLE"
 
POL_SetupWindow_Init
POL_SetupWindow_SetID 1128
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "Bethesda Softworks" "http://www.elderscrolls.com/arena/" "Pierre Etchemaite" "$PREFIX"
 
if [ -n "$POL_SELECTED_FILE" ]; then
    ARCHIVE="$POL_SELECTED_FILE"
else
    cd "$POL_USER_ROOT/tmp"
    cat <<_EOFTOU_ > arena_tou.txt
THE ELDER SCROLLS: ARENA
For Win2k/WinXP
 
IMPORTANT - PLEASE READ CAREFULLY BEFORE INSTALLING THE ELDER SCROLLS: ARENA ("THIS PRODUCT").
 
THIS IS A LEGAL DOCUMENT STATING THE TERMS AND CONDITIONS GOVERNING INSTALLATION AND USE OF THIS PRODUCT. BY CLICKING YOUR ACCEPTANCE BELOW OR BY INSTALLING OR USING THIS PRODUCT, YOU AGREE TO THE TERMS STATED HEREIN BY BETHESDA SOFTWORKS.
 
IF YOU DO NOT AGREE, DO NOT INSTALL.
 
1. You have a non-exclusive, non-transferable license and right to use this Product for your own personal use and enjoyment. This Product is not provided for any non-personal, commercial purpose. All rights not expressly granted to you herein are hereby reserved by Bethesda Softworks.
 
2. As between you and Bethesda Softworks, all rights, title and interest in and to the Product, and all worldwide intellectual property rights that are embodied in, related to, or represented by the Product, are and at all times shall remain the sole and exclusive property of Bethesda Softworks.
 
3. This Product is provided "as is." Bethesda Softworks makes no representation, warranty or covenant of any kind as to merchantability or fitness for a particular purpose or use, and disclaims any liability with respect thereto. In no event shall Bethesda Softworks, its affiliates, or their respective officers, directors, employees or agents be liable in any way to you or to any third party for any damage whatsoever that may result from use of this Product or its installation.
 
4. Neither Bethesda Softworks nor any of its affiliates will provide any technical or customer support with respect to this Product or its use by you or any third party.
 
5. You acknowledge that Bethesda Softworks owns any and all trademark, copyright and other proprietary rights to this Product.
_EOFTOU_
    POL_SetupWindow_licence "Terms of Use of Arena" "$TITLE" "$POL_USER_ROOT/tmp/arena_tou.txt"
 
 
    POL_Download "http://static.elderscrolls.com/elderscrolls.com/assets/files/tes/extras/Arena106Setup.zip" "b55b3ddcce98c1905a723781dbe1df7c"
    unzip "Arena106Setup.zip"
    ARCHIVE="$POL_USER_ROOT/tmp/Arena106.exe"
fi
 
DOCUMENT="$(dirname $ARCHIVE)/Arena106 Setup.pdf"
 
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
 
POL_Wine_WaitBefore "$TITLE"
 
POL_Wine "$ARCHIVE" || POL_Debug_Fatal "$(eval_gettext 'Error while installing archive')"
 
 
cp "$POL_USER_ROOT/tmp/Arena106 Setup.pdf" "$WINEPREFIX/drive_c/ARENA/Docs/"
 
# file doesn't recognize MSDOS batch files without @ECHO OFF
cat <<'_EOFBAT_' |perl -pe 's/\n/\r\n/' > "$WINEPREFIX/drive_c/ARENA/ARENA.BAT"
@ECHO OFF
A -sa:220 -si:7 -sd:1 -ma:220 -mq:7 -md:1 -ssbdig.adv -msbfm.adv
EXIT
_EOFBAT_
 
cat <<'_EOFCFG_' >> "$WINEPREFIX/playonlinux_dos.cfg"
dosbox_memsize=64
render_aspect=true
render_frameskip=1
cpu_cycles='max 95% limit 33000'
_EOFCFG_
# Doesn't work on OSX
[ "$POL_OS" = "Linux" ] && echo "render_scaler=hq2x" >> "$WINEPREFIX/playonlinux_dos.cfg"
 
# Icon from KingReverant http://kingreverant.deviantart.com/art/The-Elder-Scrolls-series-icons-161685128
POL_Shortcut "ARENA.BAT" "$SHORTCUT_NAME" "$SHORTCUT_NAME.png" "-delay:9 -exit" "Game;RolePlaying;"
POL_Shortcut_Document "$SHORTCUT_NAME" "$WINEPREFIX/drive_c/ARENA/Docs/Arena106 Setup.pdf"
 
POL_SetupWindow_message "$(eval_gettext 'The codes needed to exit the first dungeon can be found in the\ndocumentation;\nRight-click the game icon, "Read the manual" then check pp 4-5.')" "$TITLE"
 
POL_SetupWindow_Close
 
exit 0
