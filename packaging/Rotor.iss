#define PluginName GetEnv('PLUGIN_NAME')
#define Version GetEnv('PLUGIN_VERSION')
#define Publisher GetEnv('COMPANY_NAME')
#define Year GetDateTimeString("yyyy","","")

[Setup]
AppName={#PluginName}
AppVersion={#Version}
AppPublisher={#Publisher}
AppCopyright=Copyright (C) {#Year} {#Publisher}, LLC
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
Compression=lzma2
DefaultDirName="{commoncf64}\VST3\{#Publisher}"
DisableDirPage=yes
OutputBaseFilename={#PluginName}-{#Version}
SetupLogging=yes
SolidCompression=yes
Uninstallable=no
UsePreviousAppDir=no

; READ THE FOLLOWING!
LicenseFile="EULA"

; Types are what get displayed during setup
[Types]
Name: "standard"; Description: "Standard installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

; Components are used inside the script and can be composed of a set of Types
[Components]
name: "vst3"; Description: "VST3 Plugin (.vst3)"; Types: standard custom; Check: Is64BitInstallMode;

; MSVC adds an .ilk file when building; it should be excluded
[Files]
Source: "..\{#PluginName}.vst3"; DestDir: "{commoncf64}\VST3\{#Publisher}\"; Check: Is64BitInstallMode; Components: vst3; Flags: ignoreversion;
