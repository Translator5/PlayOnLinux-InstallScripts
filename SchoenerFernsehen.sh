#!/usr/bin/env playonlinux-bash
# A PlayOnLinux/Mac install script for SchoenerFernsehen.
# Date : (2016-03-27)
# Wine version used : 1.9.6
# Distribution used to test : Linux Mint 17.3 ROSA 64bit
# Licence : GPLv3
# Author : Translator5

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

TITLE="Schöner Fernsehen"
PREFIX="SchoenerFernsehen"
WINEVERSION="1.9.7"

POL_SetupWindow_Init
POL_Debug_Init

POL_SetupWindow_presentation "$TITLE" "Schoener-Ferhnsehen.com" "http://schoener-fernsehen.com/" "Translator5" "SchoenerFernsehen"

POL_SetupWindow_InstallMethod "LOCAL"

if [ "$INSTALL_METHOD" = "LOCAL" ]; then
	cd "$HOME"
	POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run.')" "$TITLE" "" "Windows Executables (*.exe)|*.exe;*.EXE"
	FULL_INSTALLER="$APP_ANSWER"
fi

POL_System_SetArch "x86"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"

POL_Call POL_Install_FontsSmoothBGR

Set_OS "win7"

POL_Wine_WaitBefore "$TITLE"
POL_Wine "$FULL_INSTALLER"

Set_OS "winxp"

POL_Shortcut "SchoenerFernsehen.exe" "$TITLE" "" ""

POL_SetupWindow_Close
exit
