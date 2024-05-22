:: Download and build TA-Lib source code
@echo on

:: set TALIB_C_VER=0.4.0
:: set TALIB_PY_VER=0.4.29
:: set VS_PLATFORM=x64

curl -L -o talib.zip https://sourceforge.net/projects/ta-lib/files/ta-lib/%TALIB_C_VER%/ta-lib-%TALIB_C_VER%-msvc.zip
if errorlevel 1 exit /B 1

tar -xf talib.zip
if errorlevel 1 exit /B 1

del talib\_ta_lib.c

curl -L -o talib-python.zip https://github.com/TA-Lib/ta-lib-python/archive/refs/tags/TA_Lib-%TALIB_PY_VER%.zip
if errorlevel 1 exit /B 1

tar -xf talib-python.zip --strip-components=1
if errorlevel 1 exit /B 1

git apply --verbose --binary talib.diff
if errorlevel 1 exit /B 1

:: set MSBUILDTREATHIGHERTOOLSVERSIONASCURRENT

msbuild ta-lib\c\ide\vs2022\lib_proj\ta_lib.sln /m /t:Clean;Rebuild /p:Configuration=cdr /p:Platform=%VS_PLATFORM%
if errorlevel 1 exit /B 1

copy /Y ta-lib\c\include\*.h ta-lib\

:: del pyproject.toml