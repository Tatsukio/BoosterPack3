;NSIS Modern User Interface

Unicode True

!include "MUI2.nsh"
!include "Sections.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "MUI.nsh"

;--------------------------------
;General

SetCompressor /SOLID /FINAL lzma
;SetCompressor /SOLID /FINAL zlib
!define VERSION_NUM "3.0"
!define MOD_NAME "BoosterPack"

	;Name and file
	Name "${MOD_NAME} ${VERSION_NUM}"
	!insertmacro MUI_DEFAULT MUI_ICON "installericon.ico"
	OutFile "${MOD_NAME}_${VERSION_NUM}.exe"

	;Get installation folder from registry if available
	InstallDirRegKey HKLM "SOFTWARE\${MOD_NAME}" ""

	;Request application privileges for Windows Vista
	RequestExecutionLevel admin

	;Default installation folder
	InstallDir $INSTDIR
;--------------------------------
;Interface Settings

	!define MUI_ABORTWARNING

	;Show all languages, despite user's codepage
	!define MUI_LANGDLL_ALLLANGUAGES

;--------------------------------
;Language Selection Dialog Settings

	;Remember the installer language
	!define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
	!define MUI_LANGDLL_REGISTRY_KEY "SOFTWARE\${MOD_NAME}" 
	!define MUI_LANGDLL_REGISTRY_VALUENAME "installer_language"

;--------------------------------
;Pages

	!insertmacro MUI_PAGE_COMPONENTS
	!insertmacro MUI_PAGE_DIRECTORY
	!insertmacro MUI_PAGE_INSTFILES
	!insertmacro MUI_PAGE_FINISH
	
	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES
	
;--------------------------------
;Languages
 
	!insertmacro MUI_LANGUAGE "English"
	!insertmacro MUI_LANGUAGE "French"
	!insertmacro MUI_LANGUAGE "German"
	!insertmacro MUI_LANGUAGE "Hungarian"
	!insertmacro MUI_LANGUAGE "Italian"
	!insertmacro MUI_LANGUAGE "Polish"
	!insertmacro MUI_LANGUAGE "Russian"
	!insertmacro MUI_LANGUAGE "SimpChinese"
	
;--------------------------------
;Reserve Files
	
	;If you are using solid compression, files that are required before
	;the actual installation should be stored first in the data block,
	;because this will make your installer start faster.
	
	!insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------

Function .onInit
	!insertmacro MUI_LANGDLL_DISPLAY
	InitPluginsDir
	ClearErrors
	
	ReadRegStr $INSTDIR HKLM "SOFTWARE\BoosterPack" "InstDir"
	IfErrors tryoriginal
	Goto nopwend
	
	tryoriginal:
	ReadRegStr $INSTDIR HKCU "Software\Sunflowers\ParaWorld" "InstallDir"
	IfErrors tryagain
	Goto nopwend
	
	tryagain:
	ReadRegStr $INSTDIR HKLM "SOFTWARE\Sunflowers\ParaWorld" "InstallDir"
	IfErrors nopw
	Goto nopwend
	
	nopw:
	StrCpy $INSTDIR "$(INIT_MESSAGE_INSERT_PATH)"
	
	nopwend:
	ClearErrors
FunctionEnd

;--------------------------------
;Installer Sections

Section "${MOD_NAME} ${VERSION_NUM}" SecSBasic

	SectionIn RO

	SetOutPath "$INSTDIR"
		
	;ADD YOUR OWN FILES HERE...
	File /r "BoosterPack3\"
	
	SetOutPath "$INSTDIR\"
	
	;Store installation folder
	WriteRegStr HKLM "SOFTWARE\${MOD_NAME}" "InstDir" $INSTDIR
	WriteRegStr HKLM "SOFTWARE\${MOD_NAME}" "product_version" ${VERSION_NUM}
	
	CreateShortCut "$DESKTOP\${MOD_NAME} ${VERSION_NUM}.lnk" "$INSTDIR\bin\Paraworld.exe" "-enable BoosterPack3" "$INSTDIR\Data\BoosterPack3\modicon.ico" "" "" "" ""
	
	SetOutPath "$INSTDIR"
	;WriteUninstaller "$INSTDIR\Uninstall ${MOD_NAME}.exe"
	
SectionEnd

;--------------------------------
;Descriptions

	;Language strings
	LangString DESC_SecSBasic ${LANG_ENGLISH} "The basic game files, which are required for playing."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_ENGLISH} "[insert ParaWorld directory here]"
	
	LangString DESC_SecSBasic ${LANG_FRENCH} "Les fichiers de jeu de base, qui sont nécessaires pour jouer."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_FRENCH} "[Insérer le répertoire ParaWorld ici]"
	
	LangString DESC_SecSBasic ${LANG_GERMAN} "Die Grunddaten des Spiels, die zum Spielen benötigt werden."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_GERMAN} "[trage das ParaWorld-Verzeichnis hier ein]"
	
	LangString DESC_SecSBasic ${LANG_HUNGARIAN} "A mód alapvető fájljai, amelyek nélkülözhetetlenek a működéséhez."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_HUNGARIAN} "[ide írd be a játék elérési útvonalát]"
	
	LangString DESC_SecSBasic ${LANG_ITALIAN} "I file fondamentali di gioco, che sono necessari per giocare."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_ITALIAN} "[Inseri cartella di ParaWorld qui]"
	
	LangString DESC_SecSBasic ${LANG_POLISH} "Podstawowe pliki gry, które są wymagane do grania."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_POLISH} "[Tutaj wskaż katalog gry Paraworld ]"
	
	LangString DESC_SecSBasic ${LANG_RUSSIAN} "Основные файлы, необходимые для игры."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_RUSSIAN} "[Укажите путь до ParaWorld]"
	
	LangString DESC_SecSBasic ${LANG_SIMPCHINESE} "The basic game files, which are required for playing."
	LangString INIT_MESSAGE_INSERT_PATH ${LANG_SIMPCHINESE} "[insert ParaWorld directory here]"

	;Assign language strings to sections
	!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
		!insertmacro MUI_DESCRIPTION_TEXT ${SecSBasic} $(DESC_SecSBasic)
	!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Function un.onInit

	!insertmacro MUI_UNGETLANGUAGE
	
FunctionEnd