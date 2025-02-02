@echo on

:: we're trying to avoid the third_party sources, and not building them;
:: to avoid weird errors if those sources got picked up nevertheless, delete them
rmdir /S /Q third_party\absl
rmdir /S /Q third_party\protobuf-lite

mkdir build
cd build

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX%;%LIBRARY_BIN%;%LIBRARY_LIB% ^
    -DCMAKE_INCLUDE_PATH=%LIBRARY_INC% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -Dprotobuf_BUILD_SHARED_LIBS=OFF ^
    -DSPM_ENABLE_SHARED=OFF ^
    -DSPM_USE_BUILTIN_PROTOBUF=OFF ^
    -DSPM_USE_EXTERNAL_ABSL=ON ^
    ..
IF %ERRORLEVEL% NEQ 0 exit 1

cmake --build . --config Release --target install
IF %ERRORLEVEL% NEQ 0 exit 1

if [%PKG_NAME%] == [libsentencepiece] (
    del /s /q %LIBRARY_BIN%\spm_*
)

:: clean up for rerun
cd ..
rd /s /q build
