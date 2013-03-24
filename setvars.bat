@echo off
REM *****************************************************************
REM SETVARS.BAT - Windows NT/DOS version
REM *****************************************************************
REM NOTE: Do not use this batch file directly, but copy it and
REM       modify it as necessary for your own use!!

REM Change this to point your Open Watcom source tree
set OWROOT=c:\ow\ow

REM Change following entries to point your existing Open Watcom installation
REM or comment it out to use native compiler tools
set OWBOOTSTRAP=c:\ow\ow19
set WATCOM=%OWBOOTSTRAP%
set INCLUDE=%WATCOM%\h
set PATH=%WATCOM%\binw;%PATH%
if not '%OS%' == 'Windows_NT' host_setup
set INCLUDE=%INCLUDE%;%WATCOM%\h\nt
set PATH=%WATCOM%\binnt;%PATH%
:host_setup

REM Subdirectory to be used for building OW build tools
set OWOBJDIR=binbuild

REM Set this variable to 1 to get debug build
set OWDEBUGBUILD=0

REM Set this variable to 1 to get default windowing support in clib
set OWDEFAULT_WINDOWING=0

REM Set this variable to 0 to suppress documentation build
set OWDOCBUILD=1

REM Documentation related variables

REM Change this to the PATH required by GhostScript for PDF creation on used host OS (optional)
REM set OWGHOSTSCRIPTPATH=%PATH%

REM Change these variables to point Windows help compilers which you have installed
REM set OWWIN95HC=hcrtf
REM set OWHHC=hhc

REM check if DOS is available on Windows
REM set OWDOSBOX variable to point to DOSBOX emulator
REM it can be LFN, but must not include any spaces
if not '%OS%' == 'Windows_NT' goto dos_ok
if exist %SystemRoot%\system32\dosx.exe goto dos_ok
set OWDOSBOX=dosbox
:dos_ok

REM Invoke the batch file for the common environment
call %OWROOT%\cmnvars.bat

if '%OS%' == 'Windows_NT' goto no_dos_setup
REM Change the default command prompt
prompt $p$g

REM Make the window bigger
mode 80,50
:no_dos_setup
