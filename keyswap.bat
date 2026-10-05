@echo off

REM ECHO :: Called with 1: %1  and 2: %2
SET keyPath=%USERPROFILE%\.tools\keyswap

REM ECHO :: Tool location %%keyPath set to %keyPath%
SET backupPath=%~1.xmpbk

REM ECHO :: Backup path %%backupPath set to: %backupPath%
SET curFileAbs=%~1%~2

REM ECHO :: Processing file ^> %curFileAbs%
REM ECHO :: Attempting : md "%backupPath%"

if not exist "%backupPath%\*" (
    md "%backupPath%"
    if errorlevel 1 (
		ECHO :: *** ERROR: Could not create backup directory. Aborting.
        pause
        goto :EOF
    )
)

REM ECHO :: copy "%curFileAbs%" "%backupPath%\%~2"
copy "%curFileAbs%" "%backupPath%\%~2"

ECHO :: %keyPath%\msxsl "%curFileAbs%" keyswap.xslt -o "%curFileAbs%"
%keyPath%\msxsl "%curFileAbs%" keyswap.xslt -o "%curFileAbs%"
