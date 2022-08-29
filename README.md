![example branch parameter](https://github.com/saqwed/myedk2/actions/workflows/edk2.yml/badge.svg?branch=master)

Due to tianocore separates packages into different repositories, pull these repositories into submodule and provide GitHub action example for build instruction.

<!--more-->

# Build instructions

## Ubuntu 20.04 LTS

### Setup build environment

- Build environment

```bash
sudo apt-get update
sudo apt-get install -y nasm git acpica-tools build-essential \
  crossbuild-essential-i386 crossbuild-essential-amd64 \
  crossbuild-essential-arm64 uuid-dev python3.8 python3-distutils \
  python3-pip bc gawk llvm-dev lld clang
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10
```

- Install NASM 2.15.05(edk2_stable202205 or above)

Because Ubuntu distribution still keep NASM version as 2.13.02-0.1(2022/05/28), we have to upgrade NASM by ourselves otherwise you will meet build error.

```bash
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y alien
wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/linux/nasm-2.15.05-0.fc31.x86_64.rpm -O/tmp/nasm-2.15.05-0.fc31.x86_64.rpm
sudo alien /tmp/nasm-2.15.05-0.fc31.x86_64.rpm -i
rm -f /tmp/nasm-2.15.05-0.fc31.x86_64.rpm
```

- [PR#2354 - Replace Opcode with the corresponding instructions](https://github.com/tianocore/edk2/pull/2354)
- [BaseTools: Upgrade the version of NASM tool](https://github.com/tianocore/edk2/commit/6a890db161cd6d378bec3499a1e774db3f5a27a7)
- [need help - edk2 build issue](https://edk2.groups.io/g/devel/topic/90276518)

### Clone repositories

```bash
git clone git@github.com:saqwed/myedk2.git myedk2
cd myedk2
git submodule init && git submodule update
git submodule foreach git submodule init && git submodule foreach git submodule update
```

### (Optional) Patch tools_def.txt for cross compiler

```bash
sed -i 's+DEF(GCC5_IA32_PREFIX)objcopy+ENV(GCC5_IA32_PREFIX)objcopy+g' edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC5_X64_PREFIX)objcopy+ENV(GCC5_X64_PREFIX)objcopy+g'   edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC5_IA32_PREFIX)gcc+ENV(GCC5_IA32_PREFIX)gcc+g'         edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC5_X64_PREFIX)gcc+ENV(GCC5_X64_PREFIX)gcc+g'           edk2/BaseTools/Conf/tools_def.template
export GCC5_IA32_PREFIX=i686-linux-gnu-
export GCC5_X64_PREFIX=x86_64-linux-gnu-
export GCC5_AARCH64_PREFIX=aarch64-linux-gnu-
```

### Setup edk2 build environment

```bash
make -C edk2/BaseTools
pushd $PWD && cd edk2/CryptoPkg/Library/OpensslLib/ && perl process_files.pl && popd
```

### Build

```bash
export WORKSPACE=$PWD
export PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-libc:$WORKSPACE/edk2-test:$WORKSPACE/edk2-platforms/Silicon/Intel
source edk2/edksetup.sh
build -a X64 -t GCC5 -p ShellPkg/ShellPkg.dsc -b RELEASE
```

## Windows + Visual Studio Community 2019

### Setup build environment

- Install Python 3.x
- Install [Microsoft Visual Studio community 2019](https://aka.ms/vs/16/release/vs_community.exe)
- Install [NASM 2.15.05](https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/nasm-2.15.05-win64.zip) (edk2_stable202205 or above)

  - [PR#2354 - Replace Opcode with the corresponding instructions](https://github.com/tianocore/edk2/pull/2354)
  - [BaseTools: Upgrade the version of NASM tool](https://github.com/tianocore/edk2/commit/6a890db161cd6d378bec3499a1e774db3f5a27a7)
  - [need help - edk2 build issue](https://edk2.groups.io/g/devel/topic/90276518)

### Clone repositories

```batch
git clone git@github.com:saqwed/privateedk2.git privateedk2
cd myedk2
git submodule init && git submodule update
git submodule foreach git submodule init && git submodule foreach git submodule update
```

### Setup edk2 build environment

```batch
rem Open "x86 Native Tools Command Prompt for VS 2019" via start menu
set WORKSPACE=%CD%
cd %WORKSPACE%\edk2\BaseTools
nmake
```

### Build

```batch
REM open a new command prompt
set WORKSPACE=%CD%
set PACKAGES_PATH=%WORKSPACE%/edk2;%WORKSPACE%/edk2-libc;%WORKSPACE%/edk2-test;%WORKSPACE%/edk2-platforms/Silicon/Intel
edk2\edksetup.bat VS2019
build -a X64 -t VS2019 -p ShellPkg/ShellPkg.dsc -b RELEASE
```
