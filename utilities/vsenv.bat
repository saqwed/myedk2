for /f "tokens=*" %%i in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Product.BuildTools -property installationPath') do (
REM echo %%i
	if /I [%1]==[x86] (
		call "%%i\VC\Auxiliary\Build\vcvars32.bat"
	)
	if /I [%1]==[x64] (
		call "%%i\VC\Auxiliary\Build\vcvarsx86_amd64.bat"
	)
)
