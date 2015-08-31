echo off &setlocal

echo "Usage get_printer_reg.bat cutter:[true|false]"

set cutter=%1
set printer=DS-RX1
set file_settings_cut="c:\settings_cut.dat"
set file_settings_nocut="c:\settings_nocut.dat"

set command=c:\Windows\System32\rundll32 c:\Windows\System32\printui.dll,PrintUIEntry /Ss /n "%printer%" /a 

if %cutter%==cutter:false (
	%command% %file_settings_nocut%
) else (
	%command% %file_settings_cut%
)
