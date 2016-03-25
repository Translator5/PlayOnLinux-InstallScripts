#!/usr/bin/env playonlinux-bash
# Date : (2013-02-25)
# Last revision : (2015-11-23)
# Distribution used to test : OpenSUSE 13.1
# Author : Robbz
# Licence : GPLv3
# PlayOnLinux:  playonlinux-4.2.9
 
# CHANGELOG
# [Robbz] (2014-2-10)
#   Update Wine and Patcher fix
# [Ground0] (2014-07-25)
#   Better Perfomance with Wine 1.7.22
#   Not needed installations removed.
# [petch] (2015-07-16)
#   Adding vcrun2012, needed by new game version
# [petch] (2015-11-23)
#   Switch off torrent support
# [Translator5] (2016-03-25)
#	Update Wine to 1.6.5
 
 
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
TITLE="World Of Tanks"
PREFIX="WorldOfTanks"
WORKING_WINE_VERSION="1.9.5"
PUBLISHER="BigWorld Technology"
GAME_URL="http://worldoftanks.com/"
AUTHOR="Robbz"
GAME_VMS="256" # https://na.wargaming.net/support/News/NewsItem/View/152/wot-updated-system-requirements
 
# Setup
POL_GetSetupImages "http://files.playonlinux.com/resources/setups/$PREFIX/top.jpg" "http://files.playonlinux.com/resources/setups/$PREFIX/left.jpg" "$TITLE"
POL_SetupWindow_Init
POL_SetupWindow_SetID 1592
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "$PUBLISHER" "$GAME_URL" "$AUTHOR" "$PREFIX"
 
#Select which version
POL_SetupWindow_menu "$(eval_gettext 'Which region version of World of Tanks would you like to install? Note: Korea not supported on this installation.')" "$TITLE" "North America~Europe~Russia~Asia" "~"
[ "$APP_ANSWER" = "North America" ] && REGION="na"
[ "$APP_ANSWER" = "Europe" ] && REGION="eu"
[ "$APP_ANSWER" = "Russia" ] && REGION="ru"
[ "$APP_ANSWER" = "Asia" ] && REGION="asia"
 
# Download
POL_System_TmpCreate "$PREFIX"
cd "$POL_System_TmpDir"
POL_Download "http://redirect.wargaming.net/WoT/latest_web_install_$REGION"
 
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
 
# Samba
if [ "$POL_OS" = "Mac" ]; then
    # Samba support
    POL_Call POL_GetTool_samba3
    source "$POL_USER_ROOT/tools/samba3/init"
fi
 
# Components
POL_Call POL_Install_ie8
POL_Call POL_Install_d3dx9
POL_Call POL_Install_vcrun2012
 
# Asking about memory size of graphic card
POL_SetupWindow_VMS "$GAME_VMS"
 
#Installation
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$POL_System_TmpDir/latest_web_install_$REGION"
 
# After installation, the patcher will be started asynchronously
# Kill it, we must disable Torrent download
wineserver -k
 
# Create Shortcuts
POL_Shortcut "WOTLauncher.exe" "$TITLE"
 
# Turn off Torrent updates
POL_Shortcut_InsertBeforeWine "$TITLE" 'sed -i.bak -e "s@<launcher_transport>3</launcher_transport>@<launcher_transport>2</launcher_transport>@" "$WINEPREFIX/drive_c/Games/World_of_Tanks/WoTLauncher.cfg"'
 
#Samba
if [ "$POL_OS" = "Mac" ]; then
    POL_Shortcut_InsertBeforeWine "$TITLE" "source \"$POL_USER_ROOT/tools/samba3/init\""
fi
 
POL_System_TmpDelete
 
POL_SetupWindow_Close
 
exit 0
