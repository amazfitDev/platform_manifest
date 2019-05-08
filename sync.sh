#
# Some info on building the sources of the ingenic newton 2 plus
# 2019/04/19 08:07 +200
# 
# Authors
# 	Grammatopoulos Athanasios Vasileios
# 	Grammatopoulos Apostolos
# 



# I was running ubuntu 18.04
# Get adb and fast boot
sudo apt-get install android-tools-adb android-tools-fastboot
# Other dependancies that I think you may need
sudo apt-get install git-core gnupg flex bc bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2 libxml2-utils xsltproc unzip imagemagick lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm
# You need jdk7... that you have to manualy install
# I added the openjdk repo for to install the version 8 and some other needed depenancies
sudo add-apt-repository ppa:openjdk-r/ppa  
sudo apt update
sudo apt install openjdk-8-jdk
# Then I got the packages from the experimental repo
# https://packages.debian.org/sid/libjpeg62-turbo
# https://packages.debian.org/experimental/openjdk-7-jre-headless
# https://packages.debian.org/experimental/openjdk-7-jre
# https://packages.debian.org/experimental/openjdk-7-jdk
# and installed them
sudo dpkg -i libjpeg62-turbo_*_amd64.deb
sudo dpkg -i openjdk-7-jre-headless_*_amd64.deb
sudo dpkg -i openjdk-7-jre_*_amd64.deb
sudo dpkg -i openjdk-7-jdk_*_amd64.deb
sudo apt --fix-broken install
# Then change the selected java version
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config javaws # no option, ignore
sudo update-alternatives --config javadoc




# Get repo
wget http://git.ingenic.com.cn:8082/bj/repo
chmod +x repo
./repo init -u http://git.ingenic.com.cn:8082/gerrit/mipsia/platform/manifest.git -b ingenic-android-lollipop_mr1-kernel3.10.14-newton2_plus-v3.0-20160908
./repo sync
# We failed to compile v3.0 (API errors)
#./repo forall -c "git reset --hard ingenic-android-lollipop_mr1-kernel3.10.14-newton2_plus-v3.0-20160908"
# Get v2.0
./repo forall -c "git reset --hard ingenic-android-lollipop_mr1-kernel3.10.14-newton2_plus-v2.0-20160516"
# edit build/core/clang/HOST_x86_common.mk to fix clang bug
# Add the `-B$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/x86_64-linux/bin \` on line 11
# so the lines from 8 to 12 would be:
ifeq ($(HOST_OS),linux)
CLANG_CONFIG_x86_LINUX_HOST_EXTRA_ASFLAGS := \
  --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG) \
  --sysroot=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/sysroot \
  -B$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/x86_64-linux/bin \
  -no-integrated-as
# END




# Start build
source build/envsetup.sh
lunch newton2_plus-userdebug
make update-api
make -j4
