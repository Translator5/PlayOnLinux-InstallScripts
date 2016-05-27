#!/usr/bin/env playonlinux-bash
# A PlayOnLinux/Mac install script for SchoenerFernsehen.
# Date : (2016-03-27)
# Wine version used : 1.9.6
# Distribution used to test : Linux Mint 17.3 ROSA 64bit
# Licence : GPLv3
# Author : Translator5

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

TITLE="Europa Universalis IV"
PREFIX="EuropaUniversalis4"
WINEVERSION="1.9.10"

POL_SetupWindow_Init
POL_Debug_Init

POL_SetupWindow_presentation "$TITLE" "Paradox Interactive" "http://www.europauniversalis4.com/" "Translator5" "Europa Universalis IV"

POL_SetupWindow_InstallMethod "LOCAL"

if [ "$INSTALL_METHOD" = "LOCAL" ]; then
	cd "$HOME"
	POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run.')" "$TITLE" "" "Windows Executables (*.exe)|*.exe;*.EXE"
	FULL_INSTALLER="$APP_ANSWER"
fi

POL_System_SetArch "x86"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"

POL_Call POL_Install_d3dcompiler_43
POL_Call POL_Install_d3dx9
# POL_Call POL_Install_vcrun2015

Set_OS "win7"

POL_Wine_WaitBefore "$TITLE"
POL_Wine "$FULL_INSTALLER"

Set_OS "winxp"

POL_Shortcut "eu4.exe" "$TITLE" "" ""

POL_SetupWindow_Close
exit
