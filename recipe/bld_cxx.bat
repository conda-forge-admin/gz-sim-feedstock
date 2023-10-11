rmdir /s /q build
mkdir build
cd build

if "%python_impl%" == "pypy" (
  set SKIP_PYBIND11=True
) else (
  set SKIP_PYBIND11=False
)

cmake ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    -DBUILD_TESTING:BOOL=OFF ^
    -DGZ_ENABLE_RELOCATABLE_INSTALL:BOOL=ON ^
    -DSKIP_PYBIND11:BOOL=%SKIP_PYBIND11% ^
    -DPython3_EXECUTABLE:PATH=%PYTHON% ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test.
ctest --output-on-failure -C Release
if errorlevel 1 exit 1
