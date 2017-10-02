FROM debian:stretch

WORKDIR /root

RUN apt-get update && \
    apt-get -y install lazarus qemu-system-arm imagemagick httpie wget binutils gcc git bzip2 libc-dev libc6-i386 make unzip && \
    fpc -i

COPY captured captured

RUN mkdir -p $HOME/ultibo/core && \
    mv captured/github.com/ultibohub/FPC ultibo/core/fpc && \
    mkdir -p $HOME/ultibo/core/fpc/source/packages && \
    mv captured/github.com/ultibohub/Core/source/rtl/ultibo $HOME/ultibo/core/fpc/source/rtl && \
    mv captured/github.com/ultibohub/Core/source/packages/ultibounits $HOME/ultibo/core/fpc/source/packages && \
    mv captured/github.com/ultibohub/Core/units $HOME/ultibo/core/fpc

WORKDIR /root/ultibo/core/fpc/source

RUN make distclean && \
    make all OS_TARGET=linux CPU_TARGET=x86_64 && \
    make install OS_TARGET=linux CPU_TARGET=x86_64 INSTALL_PREFIX=$HOME/ultibo/core/fpc && \
\
    cp compiler/ppcx64 ../bin/ppcx64 && \
    ../bin/fpcmkcfg -d basepath=$HOME/ultibo/core/fpc/lib/fpc/3.1.1 -o $HOME/ultibo/core/fpc/bin/fpc.cfg && \
    ../bin/fpc -i

ENV PATH=/root/ultibo/core/fpc/bin:$PATH

RUN wget -q https://launchpadlibrarian.net/287101520/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2 && \
    bunzip2 gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2 && \
    tar xf gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar && \
    rm gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar && \
    cp gcc-arm-none-eabi-5_4-2016q3/arm-none-eabi/bin/as $HOME/ultibo/core/fpc/bin/arm-ultibo-as && \
    cp gcc-arm-none-eabi-5_4-2016q3/arm-none-eabi/bin/ld $HOME/ultibo/core/fpc/bin/arm-ultibo-ld && \
    cp gcc-arm-none-eabi-5_4-2016q3/arm-none-eabi/bin/objcopy $HOME/ultibo/core/fpc/bin/arm-ultibo-objcopy && \
    cp gcc-arm-none-eabi-5_4-2016q3/arm-none-eabi/bin/objdump $HOME/ultibo/core/fpc/bin/arm-ultibo-objdump && \
    cp gcc-arm-none-eabi-5_4-2016q3/arm-none-eabi/bin/strip $HOME/ultibo/core/fpc/bin/arm-ultibo-strip && \
    rm -rf gcc-arm-none-eabi-5_4-2016q3/

RUN make distclean OS_TARGET=ultibo CPU_TARGET=arm SUBARCH=armv7a BINUTILSPREFIX=arm-ultibo- FPCOPT="-dFPC_ARMHF" CROSSOPT="-CpARMV7A -CfVFPV3 -CIARM -CaEABIHF -OoFASTMATH" FPC=$HOME/ultibo/core/fpc/bin/ppcx64 && \
    make all OS_TARGET=ultibo CPU_TARGET=arm SUBARCH=armv7a BINUTILSPREFIX=arm-ultibo- FPCOPT="-dFPC_ARMHF" CROSSOPT="-CpARMV7A -CfVFPV3 -CIARM -CaEABIHF -OoFASTMATH" FPC=$HOME/ultibo/core/fpc/bin/ppcx64 && \
    make crossinstall BINUTILSPREFIX=arm-ultibo- FPCOPT="-dFPC_ARMHF" CROSSOPT="-CpARMV7A -CfVFPV3 -CIARM -CaEABIHF -OoFASTMATH" OS_TARGET=ultibo CPU_TARGET=arm SUBARCH=armv7a FPC=$HOME/ultibo/core/fpc/bin/ppcx64 INSTALL_PREFIX=$HOME/ultibo/core/fpc && \
\
    cp $HOME/ultibo/core/fpc/source/compiler/ppcrossarm $HOME/ultibo/core/fpc/bin/ppcrossarm

COPY build-platforms.sh .
RUN ./build-platforms.sh

WORKDIR /test
COPY build-examples.sh .
RUN ./build-examples.sh

WORKDIR /workdir
