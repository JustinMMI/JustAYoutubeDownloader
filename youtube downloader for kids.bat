@echo off

:START
echo.
echo Colle l'URL de la video :
set /p URL=

echo.
echo Choisis :
echo 1 - Video seule (qualite max Premiere)
echo 2 - Audio seul (MP3)
echo 3 - Video + Audio (qualite max Premiere)
set /p CHOIX=

for /f "delims=" %%i in ('powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; if($f.ShowDialog() -eq 'OK'){ $f.SelectedPath }"') do set DOSSIER=%%i

if "%DOSSIER%"=="" goto START

echo.
echo Telechargement qualite maximale...

yt-dlp -f "bestvideo[vcodec^=avc1]+bestaudio/best[vcodec^=avc1]" -o "%DOSSIER%\temp_%%(title)s.%%(ext)s" %URL%

if errorlevel 1 (
echo Video bloquee, tentative client Android...
yt-dlp --extractor-args "youtube:player_client=android" -f "bestvideo+bestaudio/best" -o "%DOSSIER%\temp_%%(title)s.%%(ext)s" %URL%
)

if "%CHOIX%"=="2" (
for %%F in ("%DOSSIER%\temp_*") do (
ffmpeg -i "%%F" -vn -acodec libmp3lame "%DOSSIER%\%%~nF.mp3"
del "%%F"
)
goto END
)

for %%F in ("%DOSSIER%\temp_*") do (
ffmpeg -i "%%F" -c:v libx264 -preset fast -crf 18 -c:a aac "%DOSSIER%\%%~nF_premiere.mp4"
del "%%F"
)

:END
echo.
echo Telechargement termine.
echo.

goto START