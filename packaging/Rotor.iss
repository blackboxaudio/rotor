#define Version "1.0.0"
#define PluginName "Rotor"
#define Publisher "Black Box Audio"
#define Year GetDateTimeString("yyyy","","")

; Types are what get displayed during setup
[Types]
Name: "standard"; Description: "Standard installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

; Components are used inside the script and can be composed of a set of Types
[Components]
name: "vst3"; Description: "VST3 Plugin (.vst3)"; Types: standard custom

[Setup]
AppName={#PluginName}
AppVersion={#Version}
AppPublisher={#Publisher}
AppCopyright=Copyright (C) {#Year} {#Publisher}
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DefaultDirName="{commoncf64}\VST3\{#PluginName}.vst3"
DisableDirPage=yes
OutputBaseFilename={#PluginName}-{#Version}-Windows
UsePreviousAppDir=no

; READ THE FOLLOWING!
LicenseFile="EULA"

; MSVC adds an .ilk file when building; it should be excluded
[Files]
Source: "..\{#PluginName}.vst3"; DestDir: "{commoncf64}\VST3\{#PluginName}.vst3"; Components: vst3
