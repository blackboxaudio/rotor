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
name: "vst3"; Description: "VST3 plugin"; Types: standard custom

[Setup]
ArchitecturesInstallIn64BitMode=x64compatible
ArchitecturesAllowed=x64compatible
AppName={#PluginName}
OutputBaseFilename={#PluginName}-{#Version}-Windows
AppCopyright=Copyright (C) {#Year} {#Publisher}
AppPublisher={#Publisher}
AppVersion={#Version}
DefaultDirName="{commoncf64}\VST3\{#PluginName}.vst3"
DisableDirPage=yes

; READ THE FOLLOWING!
LicenseFile="EULA"

; MSVC adds an .ilk file when building; it should be excluded
[Files]
Source: "..\{#PluginName}.vst3"; DestDir: "{commoncf64}\VST3\{#PluginName}.vst3"; Components: vst3

[Run]
Filename: "{cmd}"; \
    WorkingDir: "{commoncf64}\VST3"; \
    Parameters: "/C mklink /D ""{commoncf64}\VST3\{#PluginName}Data"" ""{commonappdata}\{#PluginName}"""; \
    Flags: runascurrentuser; Components: vst3
