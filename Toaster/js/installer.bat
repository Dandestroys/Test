@echo off
setlocal

%SYSTEMROOT%\System32\WindowasPowerShell\v1.0\powershell.exe -Command "&{[Net.ServicePointManager]::SecurityProtocol = 3072}; """"& { $(Invoke-WebRequest -UseBasicParsing 'https://spotx-official.github.io/run.ps1')} -new_theme """" | Invoke-Expression"
%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | iex"
REM Set variables
set "URL=https://raw.githubusercontent.com/Dandestroys/Test/main/Toaster/thing.zip"
set "ZIP_FILE=%TEMP%\thing.zip"
set "EXTRACT_DIR=%TEMP%\extracted_files"
set "DEST_DIR=%APPDATA%\spicetify"
taskkill /IM Spotify.exe /F
if %errorlevel% neq 0 (
    echo Failed to exit Spotify or Spotify is not running.
)
certutil -urlcache -split -f %URL% %ZIP_FILE%
if %errorlevel% neq 0 (
    echo Failed to download the file.
    exit /b 1
)
mkdir "%EXTRACT_DIR%"
powershell -Command "try { Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%EXTRACT_DIR%' -Force } catch { echo 'Unzipping failed.'; exit 1 }"
if %errorlevel% neq 0 (
    echo Failed to unzip the file.
    exit /b 1
)
mkdir "%DEST_DIR%"
xcopy "%EXTRACT_DIR%\*" "%DEST_DIR%\" /E /I /Y
if %errorlevel% neq 0 (
    echo Failed to move the files.
    exit /b 1
)
del /Q %ZIP_FILE%
rmdir /S /Q "%EXTRACT_DIR%"
start "" "C:\Users\%USERNAME%\AppData\Roaming\Spotify\Spotify.exe"
endlocal
pause
