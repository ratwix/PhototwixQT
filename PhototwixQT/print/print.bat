echo off

echo "Usage print.bat duplicate:[true|false] portrait:[true|false] cutter:[true|false] source.png"

set duplicate=%1
set portrait=%2
set cutter=%3
set source=%4

set dest="c:\result_to_print.png"

set iv_path="E:\Projets\PhototwixQT\PhototwixQT\print\iview\i_view64.exe"

set printer=DS-RX1
set file_settings_cut="c:\settings_cut.dat"
set file_settings_nocut="c:\settings_nocut.dat"

set command_print=c:\Windows\System32\rundll32 c:\Windows\System32\printui.dll,PrintUIEntry /Sr /n "%printer%" /a 

convert -density 300 %source% %dest%

rem Manage duplication

if %duplicate%==duplicate:true (
	if %portrait%==portrait:true (
		convert  -quality 100 -density 300 %dest% %dest% +append %dest%
	) else (
		convert  -quality 100 -density 300 %dest% %dest% -append %dest%
	)
)

rem Rotate if paysage

if %portrait%==portrait:false (
	echo "ROTATE"
	convert -rotate 90 %dest% %dest%
)

rem Set printer register for cutter

if %cutter%==cutter:true (
		echo 'SET Cutter'
		%command_print% %file_settings_cut%
) else (
		echo 'UNSET Cutter'
		%command_print%  %file_settings_nocut%
)

rem Print with iview (add /print)

%iv_path% %dest% /print

exit
