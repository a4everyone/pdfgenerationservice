@echo off

SET timeoutsecs=30
SET bucketindir1="z:\in"
SET bucketindir2="y:\in"
SET bucketoutdir=out

:cycle
FOR %%F IN (%bucketindir1%\*) DO (
 set filename=%%~nF
 set filepath=%%F
 set outpath=z:\%bucketoutdir%
 goto printing
)
echo Nothing found in prod. Rinse and repeat

FOR %%F IN (%bucketindir2%\*) DO (
 set filename=%%~nF
 set filepath=%%F
 set outpath=y:\%bucketoutdir%
 goto printing
)
echo Nothing found in stage. Rinse and repeat

:timeoutandrepeat
timeout %timeoutsecs%
goto cycle

:printing
start cmd /c killff.bat
"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" "https://www.a4everyone.com/report/print/?data=%filename%"
call setupprint.bat %outpath%\%filename%-en.pdf
"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" "https://www.a4everyone.com/report/print/?data=%filename%&pr"

if exist success.txt (
  ren success.txt success-en.txt
) else (
REM Assume failure
  echo Bad luck. Trying again.
  goto timeoutandrepeat
)

start cmd /c killff.bat
"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" "https://www.a4everyone.com/report/print/bg/?data=%filename%"
call setupprint.bat %outpath%\%filename%-bg.pdf
"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" "https://www.a4everyone.com/report/print/bg/?data=%filename%&pr"

if exist success.txt (
  echo deleting %filepath%"
  del %filepath%"
  del success*.txt
) else (
REM Assume failure
  del success*.txt
  echo Bad luck. Trying again.
  goto timeoutandrepeat
)

echo rinse and repeat
goto cycle
