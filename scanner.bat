@echo off

SET timeoutsecs=30
SET bucketindir="z:\in"
SET bucketoutdir=z:\out

:cycle
FOR %%F IN (%bucketindir%\*) DO (
 set filename=%%~nF
 goto printing
)
echo Nothing found. Rinse and repeat
:timeoutandrepeat
timeout %timeoutsecs%
goto cycle

:printing
start cmd /c killff.bat
"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" "https://www.a4everyone.com/report/print/?data=%filename%"
call setupprint.bat %bucketoutdir%\%filename%-en.pdf
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
call setupprint.bat %bucketoutdir%\%filename%-bg.pdf
"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" "https://www.a4everyone.com/report/print/bg/?data=%filename%&pr"

if exist success.txt (
  echo deleting %bucketindir%\"%filename%"
  del %bucketindir%\"%filename%"
  del success*.txt
) else (
REM Assume failure
  del success*.txt
  echo Bad luck. Trying again.
  goto timeoutandrepeat
)

echo rinse and repeat
goto cycle
