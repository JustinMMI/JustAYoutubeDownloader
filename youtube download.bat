@echo off

:START
echo.
echo Colle l'URL de la video :
set /p URL=

echo.
echo Choisis ce que tu veux telecharger :
echo 1 - Video seulement (H264 MP4)
echo 2 - Audio seulement (MP3)
echo 3 - Video + Audio fusionnes (MP4 compatible Premiere)
set /p CHOIX=

for /f "delims=" %%i in ('powershell -ExecutionPolicy Bypass -File "%~dp0select_save_folder.ps1"') do set DOSSIER=%%i

if "%DOSSIER%"=="" (
echo Aucun dossier choisi.
goto START
)

echo.
echo Detection de la plateforme...

set FORMAT=

echo %URL% | find "youtube" >nul
if not errorlevel 1 set FORMAT=bv*[vcodec^^=avc]+ba/b[vcodec^^=avc]

echo %URL% | find "youtu.be" >nul
if not errorlevel 1 set FORMAT=bv*[vcodec^^=avc]+ba/b[vcodec^^=avc]

echo %URL% | find "dailymotion" >nul
if not errorlevel 1 set FORMAT=bestvideo+bestaudio/best

if "%FORMAT%"=="" set FORMAT=bestvideo+bestaudio/best

echo Format utilise : %FORMAT%
echo.

if "%CHOIX%"=="1" (
yt-dlp -f "%FORMAT%" -o "%DOSSIER%\%%(title)s.%%(ext)s" %URL%
)

if "%CHOIX%"=="2" (
yt-dlp -x --audio-format mp3 -o "%DOSSIER%\%%(title)s.%%(ext)s" %URL%
)

if "%CHOIX%"=="3" (
yt-dlp -f "%FORMAT%" --merge-output-format mp4 -o "%DOSSIER%\%%(title)s.%%(ext)s" %URL%
)

echo.
echo Telechargement termine.
echo.

goto START