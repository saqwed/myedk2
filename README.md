![windows badge](https://github.com/saqwed/myedk2/actions/workflows/windows.yml/badge.svg?branch=master)
![ubuntu badge](https://github.com/saqwed/myedk2/actions/workflows/ubuntu.yml/badge.svg?branch=master)
![ubuntu-intel-miniplatform badge](https://github.com/saqwed/myedk2/actions/workflows/ubuntu-intel-miniplatform.yml/badge.svg?branch=master)

Due to tianocore separates packages into different repositories, pull these repositories into submodule and provide GitHub action example for build instruction.

<!--more-->

# Build instructions

## Ubuntu 22.04 LTS

### Setup Ubuntu build environment

- Build environment

```bash
sudo apt-get update
sudo apt-get install -y nasm git acpica-tools build-essential \
  crossbuild-essential-i386 crossbuild-essential-amd64 \
  crossbuild-essential-arm64 uuid-dev python3 python3-distutils \
  python3-pip bc gawk llvm-dev lld clang
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10
```

### Clone repositories

```bash
git clone https://github.com/saqwed/myedk2.git myedk2 --recursive
```

### (Optional) Patch tools_def.txt for cross compiler

```bash
sed -i 's+DEF(GCC_IA32_PREFIX)objcopy+ENV(GCC_IA32_PREFIX)objcopy+g' edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC_X64_PREFIX)objcopy+ENV(GCC_X64_PREFIX)objcopy+g'   edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC_IA32_PREFIX)gcc+ENV(GCC_IA32_PREFIX)gcc+g'         edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC_X64_PREFIX)gcc+ENV(GCC_X64_PREFIX)gcc+g'           edk2/BaseTools/Conf/tools_def.template
export GCC_IA32_PREFIX=i686-linux-gnu-
export GCC_X64_PREFIX=x86_64-linux-gnu-
export GCC_AARCH64_PREFIX=aarch64-linux-gnu-
```

### Setup edk2 build environment

```bash
make -C edk2/BaseTools
```

### Build

```bash
export WORKSPACE=$PWD
ln -s $WORKSPACE/edk2-test/uefi-sct/SctPkg/ $WORKSPACE/SctPkg
export PACKAGES_PATH=$WORKSPACE/edk2
export PACKAGES_PATH=$PACKAGES_PATH:$WORKSPACE/edk2-platforms
export PACKAGES_PATH=$PACKAGES_PATH:$WORKSPACE/edk2-platforms/Platform/Intel
export PACKAGES_PATH=$PACKAGES_PATH:$WORKSPACE/edk2-platforms/Silicon/Intel
export PACKAGES_PATH=$PACKAGES_PATH:$WORKSPACE/edk2-platforms/Features/Intel
export PACKAGES_PATH=$PACKAGES_PATH:$WORKSPACE/edk2-libc
export PACKAGES_PATH=$PACKAGES_PATH:$WORKSPACE/edk2-test
export PACKAGES_PATH=$PACKAGES_PATH:$WORKSPACE/SctPkg
source edk2/edksetup.sh
build -a X64 -t GCC -p ShellPkg/ShellPkg.dsc -b RELEASE
```

## Windows + Visual Studio Community 2019

### Setup Windows build environment

- Install Python 3.x
- Install [Microsoft Visual Studio community 2019](https://aka.ms/vs/16/release/vs_community.exe)
- Install [NASM 2.16.03](https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/win64/nasm-2.16.03-win64.zip) (edk2_stable202205 or above)

  - [PR#2354 - Replace Opcode with the corresponding instructions](https://github.com/tianocore/edk2/pull/2354)
  - [BaseTools: Upgrade the version of NASM tool](https://github.com/tianocore/edk2/commit/6a890db161cd6d378bec3499a1e774db3f5a27a7)
  - [need help - edk2 build issue](https://edk2.groups.io/g/devel/topic/90276518)

### Clone repositories

```batch
git clone https://github.com/saqwed/myedk2.git myedk2 --recursive
```

### Setup edk2 build environment

```batch
rem Open "x86 Native Tools Command Prompt for VS 2019" via start menu
set WORKSPACE=%CD%
cd %WORKSPACE%\edk2
set EDK_TOOLS_PATH=%WORKSPACE%\edk2\BaseTools
edksetup.bat VS2019
cd %WORKSPACE%\edk2\BaseTools
toolsetup.bat
nmake
```

Exit this command prompt windows and reopen another one for next steps.

### Build

```batch
REM open a new command prompt
set WORKSPACE=%CD%
mklink /D %WORKSPACE%\SctPkg %WORKSPACE%\edk2-test\uefi-sct\SctPkg
set PACKAGES_PATH=%WORKSPACE%/edk2
set PACKAGES_PATH=%PACKAGES_PATH%;%WORKSPACE%/edk2-platforms
set PACKAGES_PATH=%PACKAGES_PATH%;%WORKSPACE%/edk2-platforms/Platform/Intel
set PACKAGES_PATH=%PACKAGES_PATH%;%WORKSPACE%/edk2-platforms/Silicon/Intel
set PACKAGES_PATH=%PACKAGES_PATH%;%WORKSPACE%/edk2-platforms/Features/Intel
set PACKAGES_PATH=%PACKAGES_PATH%;%WORKSPACE%/edk2-libc
set PACKAGES_PATH=%PACKAGES_PATH%;%WORKSPACE%/edk2-test
set PACKAGES_PATH=%PACKAGES_PATH%;%WORKSPACE%/SctPkg
edk2\edksetup.bat VS2019
build -a X64 -t VS2019 -p ShellPkg/ShellPkg.dsc -b RELEASE
```

### VSCode Extension - note

- Install [Edk2code](https://marketplace.visualstudio.com/items?itemName=intel-corporation.edk2code) extension
- Pass `-Y COMPILE_INFO -y BuildReport.log` for the extension requirement.
- Open **WORKSPACE**, run command `EDK2: Rebuild index database` from the command palette, select `Build` folder.
  - Detail can be found in [Index source code](https://github.com/intel/Edk2Code/wiki/Index-source-code)

### Activity

![Alt](https://repobeats.axiom.co/api/embed/f453d58c114a98896a478023233940d0db153ceb.svg "Repobeats analytics image")
