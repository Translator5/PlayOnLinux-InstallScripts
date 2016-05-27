#!/usr/bin/env playonlinux-bash
# Date : (2013-02-22 ??-??)
# Last revision : (2015-11-17 10-38)
# Distribution used to test : Gentoo amd64
# Author : Robbz
# Licence : GPLv3
# PlayOnLinux:  playonlinux-4.2.8
 
# CHANGELOG
# [SuperPlumus] (2013-07-24 11-32)
#   Update gettext messages
# [Bratzmeister] (2015-11-17 10-38)
#   added Support for the new mandatory 64bit client and improved fps with CSMT
# [Translator5] (2016-01-03)
#   Update Wine
 
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
TITLE="PlanetSide 2"
PREFIX="PlanetSide2"
WORKING_WINE_VERSION="1.9.10"
PUBLISHER="Sony Entertainment"
GAME_URL="https://www.planetside2.com/"
AUTHOR="Robbz"
 
# Setup
 
 
POL_GetSetupImages "http://files.playonlinux.com/resources/setups/$PREFIX/top.jpg" "http://files.playonlinux.com/resources/setups/$PREFIX/left.jpg" "$TITLE"
POL_SetupWindow_Init
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "$PUBLISHER" "$GAME_URL" "$AUTHOR" "$PREFIX"
 
POL_System_SetArch "amd64"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
 
# Components
POL_Call POL_Install_vcrun2008
POL_Call POL_Install_d3dx9_43
POL_Call POL_Install_d3dcompiler_43
POL_Call POL_Install_dxdiag
#POL_Call POL_Install_dxfullsetup
 
# enable CSMT
POL_Wine_UpdateRegistryWinePair 'DllRedirects' 'wined3d' 'wined3d-csmt.dll'
 
# Asking about memory size of graphic card
#POL_SetupWindow_VMS $GAME_VMS
 
# Download
cd "$WINEPREFIX/drive_c"
POL_Download "https://launch.daybreakgames.com/installer/PS2_setup.exe"
 
POL_SetupWindow_message "$(eval_gettext 'Attention: After installation is complete, the patcher will load. Please close the patcher before logging in to complete the installation. After this, you can run "$TITLE" when setup is done')" "$TITLE"
 
POL_Wine_WaitBefore "$TITLE"
POL_Wine start /unix "$WINEPREFIX/drive_c/PS2_setup.exe"
POL_Wine_WaitExit "$TITLE"
 
# Create Shortcuts
POL_Shortcut "LaunchPad.exe" "$TITLE" "$TITLE.png"
 
POL_SetupWindow_Close
 
exit 0
