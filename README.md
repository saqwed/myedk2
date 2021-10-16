![example branch parameter](https://github.com/saqwed/myedk2/actions/workflows/edk2.yml/badge.svg?branch=master)

Due to tianocore separates packages into different repositories, pull these repositories into submodule and provide GitHub action example for build instruction.

<!--more-->

# Local build instructions

- OS

ubuntu 20.04 LTS

- Setup build environment

```bash
sudo apt-get update
sudo apt-get install -y nasm \
                        git \
                        acpica-tools \
                        build-essential \
                        crossbuild-essential-i386 \
                        crossbuild-essential-amd64 \
                        crossbuild-essential-arm64 \
                        uuid-dev \
                        python3.8 \
                        python3-distutils \
                        python3-pip \
                        bc \
                        gawk \
                        llvm-dev \
                        lld \
                        clang
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10
```

- Clone repositories

```bash
git clone git@github.com:saqwed/myedk2.git myedk2
cd myedk2
git submodule init && git submodule update
git submodule foreach git submodule init && git submodule foreach git submodule update
```

- (Optional) Patch tools_def.txt for cross compiler

```bash
sed -i 's+DEF(GCC5_IA32_PREFIX)objcopy+ENV(GCC5_IA32_PREFIX)objcopy+g' edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC5_X64_PREFIX)objcopy+ENV(GCC5_X64_PREFIX)objcopy+g'   edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC5_IA32_PREFIX)gcc+ENV(GCC5_IA32_PREFIX)gcc+g'         edk2/BaseTools/Conf/tools_def.template
sed -i 's+DEF(GCC5_X64_PREFIX)gcc+ENV(GCC5_X64_PREFIX)gcc+g'           edk2/BaseTools/Conf/tools_def.template
export GCC5_IA32_PREFIX=i686-linux-gnu-
export GCC5_X64_PREFIX=x86_64-linux-gnu-
export GCC5_AARCH64_PREFIX=aarch64-linux-gnu-
```

- Setup edk2 build environment

```bash
make -C edk2/BaseTools
pushd $PWD && cd edk2/CryptoPkg/Library/OpensslLib/ && perl process_files.pl && popd
```

- Build

```bash
export WORKSPACE=$PWD
export PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-libc:$WORKSPACE/edk2-test:$WORKSPACE/edk2-platforms/Silicon/Intel
source edk2/edksetup.sh
build -a X64 -t GCC5 -p ShellPkg/ShellPkg.dsc -b RELEASE
```
