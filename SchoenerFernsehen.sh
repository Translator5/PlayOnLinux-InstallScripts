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
WINEVERSION="1.9.6"

POL_SetupWindow_Init
POL_Debug_Init

POL_SetupWindow_presentation "$TITLE" "Schoener-Fernsehen" "http://www.smitegame.com/" "Translator5" "SchoenerFernsehen"

POL_SetupWindow_InstallMethod "DOWNLOAD,LOCAL"

if [ "$INSTALL_METHOD" = "LOCAL" ]; then
	cd "$HOME"
	POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run.')" "$TITLE" "" "Windows Executables (*.exe)|*.exe;*.EXE"
	FULL_INSTALLER="$APP_ANSWER"
else
	POL_System_TmpCreate "$PREFIX"
 
	DOWNLOAD_URL="http://schoener-fernsehen.com/files/SchoenerFernsehen_install_0.0.0.2c.exe"
	DOWNLOAD_MD5="7E3407747E005FE6120B7F5E858883A9"
	DOWNLOAD_FILE="$POL_System_TmpDir/$(basename "$DOWNLOAD_URL")"
 
	POL_Call POL_Download_retry "$DOWNLOAD_URL" "$DOWNLOAD_FILE" "$DOWNLOAD_MD5" "$TITLE installer"
 
	FULL_INSTALLER="$DOWNLOAD_FILE"
fi

POL_System_SetArch "x86"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"

if [ "$POL_OS" = "Linux" ]; then
	POL_Call POL_Function_RootCommand "echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope; exit"
fi

POL_Call POL_Install_FontsSmoothBGR
POL_Call POL_Install_FontsSmoothGrayScale
POL_CAll POL_Install_FontsSmoothRGB
POL_Call POL_Install_AdobeAir
POL_Call POL_Install_xvid
POL_Call POL_Install_Flashplayer_ActiveX
POL_Call POL_Install_gdiplus
POL_Call POL_Install_xact

Set_OS "win7"

POL_Wine_WaitBefore "$TITLE"
POL_Wine "$FULL_INSTALLER"

Set_OS "winxp"

POL_Call POL_Function_OverrideDLL builtin,native dnsapi
POL_Shortcut "SchoenerFernsehen.exe" "$TITLE" "" ""

if [ "$INSTALL_METHOD" = "DOWNLOAD" ]; then
	POL_System_TmpDelete
fi

POL_SetupWindow_Close
exit
