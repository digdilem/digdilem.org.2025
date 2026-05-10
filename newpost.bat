@echo off
setlocal

:: Check for the first argument (Group)
if "%~1"=="" (
    echo Error: Missing the first argument [Group].
    echo Usage: %~nx0 [group] [filename]
    exit /b 1
)

:: Check for the second argument (Filename)
if "%~2"=="" (
    echo Error: Missing the second argument [Filename].
    echo Usage: %~nx0 %1 [filename]
    exit /b 1
)

:: Configuration
set "TARGET_DIR=C:\code\digdilem"
set "GROUP=%~1"
set "FILENAME=%~2"

:: Change directory and execute
c:
cd "%TARGET_DIR%" || (
    echo Error: Could not find directory %TARGET_DIR%
    exit /b 1
)

echo Creating new post in %GROUP%...
hugo new "%GROUP%/%FILENAME%/_index.md"

endlocal

