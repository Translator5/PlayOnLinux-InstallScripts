#!/usr/bin/env playonlinux-bash
# A PlayOnLinux/Mac install script for SMITE.
# Date : (2015-08-18)
# Last revision : (2016-03-24 22:22)
# Wine version used : 1.9.7
# Distribution used to test : Linux Mint 17.3 ROSA 64bit
# Licence : GPLv3
# Author : Rolando Islas

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

TITLE="Endless Legend"
PREFIX="ENDLESSLEGEND"
WINEVERSION="1.9.10"

POL_SetupWindow_Init
POL_Debug_Init

POL_SetupWindow_presentation "$TITLE" "Amplitude Studio" "http://www.endless-legend.com/" "Translator5" "Endless Legend"

POL_SetupWindow_InstallMethod "LOCAL"

	[ "$INSTALL_METHOD" = "LOCAL" ]; then
	cd "$HOME"
	POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run.')" "$TITLE" "" "Windows Executables (*.exe)|*.exe;*.EXE"
	FULL_INSTALLER="$APP_ANSWER"

POL_System_SetArch "x86"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"

if [ "$POL_OS" = "Linux" ]; then
	POL_Call POL_Function_RootCommand "echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope; exit"
fi

POL_Call POL_Install_dotnet35sp1
POL_Call POL_Install_dotnet40
POL_Call POL_Install_vcrun2010

Set_OS "win7"

POL_Wine_WaitBefore "$TITLE"
POL_Wine "$FULL_INSTALLER"

Set_OS "winxp"

POL_Call POL_Function_OverrideDLL builtin,native dnsapi
POL_Shortcut "Launcher.exe" "$TITLE" "" ""
POL_Shortcut "EndlessLegend.exe" "Play Endless Legend" "" ""

POL_SetupWindow_Close
exit
