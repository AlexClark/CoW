@echo off
if "%1" == "" (
  set FILES=*.nss
) else (
  set FILES=%1
)
set DIR=%cd%
if EXIST temp0 cd temp0
C:\Users\Draco\Utils\nwnsc.exe -n "D:\Steam\steamapps\common\Neverwinter Nights" -i D:\Projects\NWN_CoW\ %FILES%
del *.ndb
cd %DIR%