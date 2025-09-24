; Inno Setup Script for FramePack Studio
; This script creates an installer for FramePack Studio application
[Setup]
AppName=FramePack Studio
AppVersion=1.0.0
AppPublisher=FramePack Team
AppPublisherURL=https://github.com/framepack
AppSupportURL=https://github.com/framepack/studio/issues
AppUpdatesURL=https://github.com/framepack/studio/releases
DefaultDirName={autopf}\FramePack Studio
DefaultGroupName=FramePack Studio
AllowNoIcons=yes
LicenseFile=LICENSE.txt
InfoBeforeFile=README.txt
OutputDir=dist
OutputBaseFilename=FramePackStudio-Setup-{#SetupSetting("AppVersion")}
; SetupIconFile=icons\app.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
MinVersion=6.1sp1
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1
Name: "associate"; Description: "Associate .fpk files with FramePack Studio"; GroupDescription: "File associations:"
[Files]
Source: "build\FramePackStudio.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\*.dll"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "assets\*"; DestDir: "{app}\assets"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "LICENSE.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.txt"; DestDir: "{app}"; Flags: ignoreversion isreadme
[Icons]
Name: "{group}\FramePack Studio"; Filename: "{app}\FramePackStudio.exe"
Name: "{group}\{cm:UninstallProgram,FramePack Studio}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\FramePack Studio"; Filename: "{app}\FramePackStudio.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\FramePack Studio"; Filename: "{app}\FramePackStudio.exe"; Tasks: quicklaunchicon
[Registry]
Root: HKCR; Subkey: ".fpk"; ValueType: string; ValueName: ""; ValueData: "FramePackFile"; Flags: uninsdeletevalue; Tasks: associate
Root: HKCR; Subkey: "FramePackFile"; ValueType: string; ValueName: ""; ValueData: "FramePack Studio File"; Flags: uninsdeletekey; Tasks: associate
Root: HKCR; Subkey: "FramePackFile\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\FramePackStudio.exe,0"; Tasks: associate
Root: HKCR; Subkey: "FramePackFile\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\FramePackStudio.exe"" ""%1"""; Tasks: associate
[Run]
Filename: "{app}\FramePackStudio.exe"; Description: "{cm:LaunchProgram,FramePack Studio}"; Flags: nowait postinstall skipifsilent
[Code]
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
  Result := 0;
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;
end;
