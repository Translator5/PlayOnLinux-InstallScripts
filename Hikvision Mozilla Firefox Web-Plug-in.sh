#!/usr/bin/env playonlinux-bash
 
# Date : (2016-03-28 22:22)
# Distribution used to test : LinuxMint 17.3
# Author : SuperPlumus, Translator5
 
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
TITLE="Mozilla Firefox"
PREFIX="MozillaFirefox"
WORKING_WINE_VERSION="1.9.6"
 
PLUGIN_NAME_FLASH="Flash Player"
PLUGIN_NAME_SHOCKWAVE="Shockwave Player"
 
PLUGIN_FILE_SHOCKWAVE="Shockwave_Installer_Full.exe"
PLUGIN_URL_SHOCKWAVE="http://fpdownload.macromedia.com/get/shockwave/default/english/win95nt/latest/$PLUGIN_FILE_SHOCKWAVE"
 
# Fonction pour simplifier l'utilisation de POL_SetupWindow_checkbox_list
is_checked ()
{
    if [ "$(echo "$CHECKS" | grep -o "$1")" != "" ]; then
        return 0
    else
        return 1
    fi
}
 
POL_GetSetupImages "$SITE/setups/firefox/top.jpg" "$SITE/setups/firefox/left.jpg" "$TITLE"
POL_SetupWindow_Init
POL_SetupWindow_SetID 856
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "Mozilla" "http://www.mozilla.com" "SuperPlumus" "$PREFIX"
 
 
POL_Wine_EnableOSXNativeDock # A new feature for PlayOnMac. Firefox is the first test
 
POL_System_TmpCreate "$PREFIX"
 
if [ -n "$POL_SELECTED_FILE" ]; then
    INSTALLER="$POL_SELECTED_FILE"
else
    POL_SetupWindow_InstallMethod "LOCAL,DOWNLOAD"
 
    if [ "$INSTALL_METHOD" = "DOWNLOAD" ]; then
        # Language version
        POL_SetupWindow_menu "$(eval_gettext 'Which language version would you like to install?')" "$TITLE" "Afrikaans~Albanian~Arabic~Asturian~Basque~Belarusian~Bengali (Bangladesh)~Bengali (India)~Breton~Bulgarian~Catalan~Chinese (Simplified)~Chinese (Traditional)~Croatian~Czech~Danish~Dutch~English (British)~English (South African)~English (US)~Esperanto~Estonian~Finnish~French~Frisian~Gaelic (Scotland)~Galician~German~Greek~Gujarati~Hebrew~Hindi (India)~Hungarian~Indonesian~Icelandic~Irish (Ireland)~Italian~Japanese~Kannada~Korean~Latvian~Lithuanian~Macedonian~Malayalam~Marathi~Norwegian (Bokmål)~Norwegian (Nynorsk)~Persian~Polish~Portuguese (Brazilian)~Portuguese (Portugal)~Punjabi~Romanian~Romansh~Russian~Sinhala~Slovak~Slovenian~Spanish (Argentina)~Spanish (Chile)~Spanish (Mexico)~Spanish (Spain)~Swedish~Telugu~Thai~Turkish~Ukrainian~Vietnamese~Welsh" "~"
 
        case "$APP_ANSWER" in
            "Afrikaans") FIREFOX_LANG="af" ;;
            "Albanian") FIREFOX_LANG="sq" ;;
            "Arabic") FIREFOX_LANG="ar" ;;
            "Asturian") FIREFOX_LANG="ast" ;;
            "Basque") FIREFOX_LANG="eu" ;;
            "Belarusian") FIREFOX_LANG="be" ;;
            "Bengali (Bangladesh)") FIREFOX_LANG="bn-BD" ;;
            "Bengali (India)") FIREFOX_LANG="bn-IN" ;;
            "Breton") FIREFOX_LANG="br" ;;
            "Bulgarian") FIREFOX_LANG="bg" ;;
            "Catalan") FIREFOX_LANG="ca" ;;
            "Chinese (Simplified)") FIREFOX_LANG="zh-CN" ;;
            "Chinese (Traditional)") FIREFOX_LANG="zh-TW" ;;
            "Croatian") FIREFOX_LANG="hr" ;;
            "Czech") FIREFOX_LANG="cs" ;;
            "Danish") FIREFOX_LANG="da" ;;
            "Dutch") FIREFOX_LANG="nl" ;;
            "English (British)") FIREFOX_LANG="en-GB" ;;
            "English (South African)") FIREFOX_LANG="en-ZA" ;;
            "English (US)") FIREFOX_LANG="en-US" ;;
            "Esperanto") FIREFOX_LANG="eo" ;;
            "Estonian") FIREFOX_LANG="et" ;;
            "Finnish") FIREFOX_LANG="fi" ;;
            "French") FIREFOX_LANG="fr" ;;
            "Frisian") FIREFOX_LANG="fy-NL" ;;
            "Gaelic (Scotland)") FIREFOX_LANG="gd" ;;
            "Galician") FIREFOX_LANG="gl" ;;
            "German") FIREFOX_LANG="de" ;;
            "Greek") FIREFOX_LANG="el" ;;
            "Gujarati") FIREFOX_LANG="gu-IN" ;;
            "Hebrew") FIREFOX_LANG="he" ;;
            "Hindi (India)") FIREFOX_LANG="hi-IN" ;;
            "Hungarian") FIREFOX_LANG="hu" ;;
            "Icelandic") FIREFOX_LANG="is" ;;
            "Indonesian") FIREFOX_LANG="id" ;;
            "Irish (Ireland)") FIREFOX_LANG="ga-IE" ;;
            "Italian") FIREFOX_LANG="it" ;;
            "Japanese") FIREFOX_LANG="ja" ;;
            "Kannada") FIREFOX_LANG="kn" ;;
            "Korean") FIREFOX_LANG="ko" ;;
            "Latvian") FIREFOX_LANG="lv" ;;
            "Lithuanian") FIREFOX_LANG="lt" ;;
            "Macedonian") FIREFOX_LANG="mk" ;;
            "Malayalam") FIREFOX_LANG="ml" ;;
            "Marathi") FIREFOX_LANG="mr" ;;
            "Norwegian (Bokmål)") FIREFOX_LANG="nb-NO" ;;
            "Norwegian (Nynorsk)") FIREFOX_LANG="nn-NO" ;;
            "Persian") FIREFOX_LANG="fa" ;;
            "Polish") FIREFOX_LANG="pl" ;;
            "Portuguese (Brazilian)") FIREFOX_LANG="pt-BR" ;;
            "Portuguese (Portugal)") FIREFOX_LANG="pt-PT" ;;
            "Punjabi") FIREFOX_LANG="pa-IN" ;;
            "Romanian") FIREFOX_LANG="ro" ;;
            "Romansh") FIREFOX_LANG="rm" ;;
            "Russian") FIREFOX_LANG="ru" ;;
            "Sinhala") FIREFOX_LANG="si" ;;
            "Slovak") FIREFOX_LANG="sk" ;;
            "Slovenian") FIREFOX_LANG="sl" ;;
            "Spanish (Argentina)") FIREFOX_LANG="es-AR" ;;
            "Spanish (Chile)") FIREFOX_LANG="es-CL" ;;
            "Spanish (Mexico)") FIREFOX_LANG="es-MX" ;;
            "Spanish (Spain)") FIREFOX_LANG="es-ES" ;;
            "Swedish") FIREFOX_LANG="sv-SE" ;;
            "Telugu") FIREFOX_LANG="te" ;;
            "Thai") FIREFOX_LANG="th" ;;
            "Turkish") FIREFOX_LANG="tr" ;;
            "Ukrainian") FIREFOX_LANG="uk" ;;
            "Vietnamese") FIREFOX_LANG="vi" ;;
            "Welsh") FIREFOX_LANG="cy" ;;
            *) POL_Debug_Fatal "$APP_ANSWER : Incorrect value, bug." ;;
        esac
 
        # Detection de la derniere version
        cd "$POL_System_TmpDir"
     
        # https://download-installer.cdn.mozilla.net/pub/firefox/releases/latest/README.txt
        # No MD5, since the script uses the latest installer version available
        POL_Download "https://download.mozilla.org/?product=firefox-latest&os=win&lang=$FIREFOX_LANG"
        INSTALLER="$POL_System_TmpDir/FirefoxSetup.exe"
        POL_System_mv "$POL_System_TmpDir/?product=firefox-latest&os=win&lang=$FIREFOX_LANG" "$INSTALLER"
 
    elif [ "$INSTALL_METHOD" = "LOCAL" ]; then
        cd "$HOME"
        POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run')" "$TITLE"
        INSTALLER="$APP_ANSWER"
    fi
fi
 
AVAILABLE_PLUGINS="$PLUGIN_NAME_FLASH~$PLUGIN_NAME_SHOCKWAVE"
 
POL_SetupWindow_checkbox_list "$(eval_gettext 'Check which components do you want to install additionally:')" "$TITLE" "$AVAILABLE_PLUGINS" "~"
CHECKS="$APP_ANSWER"
 
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
 
POL_Call POL_Install_LunaTheme
 
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$INSTALLER"
 
cd "$POL_System_TmpDir"
 
# Flash Player
if is_checked "$PLUGIN_NAME_FLASH"; then
    POL_Call POL_Install_flashplayer
fi
 
# Shockwave Player
if is_checked "$PLUGIN_NAME_SHOCKWAVE"; then
    POL_Download "$PLUGIN_URL_SHOCKWAVE" ""
    POL_Wine_WaitBefore "$PLUGIN_NAME_SHOCKWAVE"
    Set_OS "win2k"
    POL_Wine "$PLUGIN_FILE_SHOCKWAVE"
    Set_OS "winxp"
    POL_Wine_WaitExit "$PLUGIN_NAME_SHOCKWAVE"
fi

POL_SetupWindow_InstallMethod "LOCAL"
 
    if  [ "$INSTALL_METHOD" = "LOCAL" ]; then
        cd "$HOME"
        POL_SetupWindow_browse "$(eval_gettext 'Please select the Webplugin-setup file to run')" "$TITLE"
        INSTALLER="$APP_ANSWER"
    fi
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$INSTALLER"

# Disables plugin container (that makes Firefox crash on pages that already used flash/shockwave)
#echo "pref("dom.ipc.plugins.enabled", false);" > "$WINEPREFIX/drive_c/$PROGRAMFILES/Mozilla Firefox/defaults/pref/firefox.js"
 
POL_System_TmpDelete
 
POL_Shortcut "firefox.exe" "$TITLE"
 
POL_SetupWindow_Close
 
exit
