#!/bin/bash

# VERSIONS
KERNEL_VERSION=5.19.9
BUSYBOX_VERSION=1.36.0

prepare_env() {
    mkdir -p src/
    mkdir -p output/
    apt-get install bison flex libelf-dev
}

get_and_build_busybox() {
    echo "Getting BusyBox..."

    cd src/

    wget https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
    tar -xf busybox-$BUSYBOX_VERSION.tar.bz2

    cd busybox-$BUSYBOX_VERSION

    make defconfig

    sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
    sed -i 's/CONFIG_FEATURE_IFUPDOWN_UDHCPC=y/CONFIG_FEATURE_IFUPDOWN_UDHCPC=n/' .config
    sed -i 's/CONFIG_FEATURE_DNSD_NODNS=y/CONFIG_FEATURE_DNSD_NODNS=n/' .config

    make || exit

    cd .. 

    cd ..
}

get_and_build_kernel() {
    echo "Getting kernel..."

    cd src/

    KERNEL_MAJOR_VERSION="${KERNEL_VERSION%%.*}"
    wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR_VERSION.x/linux-$KERNEL_VERSION.tar.xz
    tar -xf linux-$KERNEL_VERSION.tar.xz

    cd linux-$KERNEL_VERSION

    make defconfig
    make -j8 || exit

    cp arch/x86_64/boot/bzImage ../../output/

    cd ..

    cd ..
}

create_initrd() {
    echo "Creating rootfs..."
    mkdir -p output/initrd
    cd output/initrd

    mkdir -p bin dev proc sys

    cd bin
    
    cp ../../../src/busybox-$BUSYBOX_VERSION/busybox ./
    for program in $(./busybox --list); do
        ln -s /bin/busybox ./$program
    done

    cd ..

    cd ..
}

add_init_script() {
    echo "Adding init script..."
    cp init output/initrd/init
    chmod -R 777 output/initrd/init
}

create_image() {
    echo "Creating image..."
    find output/initrd | cpio -o -H newc > output/initrd.img
}

run_image() {
    echo "Running..."
    
}

main() {
    # get_versions
    # prepare_env
    # get_and_build_busybox
    # get_and_build_kernel
    # create_initrd
    # add_init_script
    # create_image
    run_image
}

main


#!/bin/bash

build() {
	# get kernel src
	wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.5.2.tar.xz
	tar -xf linux-6.5.2.tar.xz

	# build the kernel
	cd linux-6.5.2
	make x86_64_defconfig
	make -j $(nproc)

	# create filesystem
	mkdir -p vfs
	echo hello.c << EOF
#include <stdio.h>
int main() {
printf("Hello, Kernel!");
return 0;
}
EOF
	gcc --static hello.c -o init
	find . | cpio -o -H newc > vfs.img

	# move & clear
	cp arch/x86_64/boot/bzImage ../bzImage
	cp vfs/vfs.img ../vfs.img

	cd ..
	rm -rf linux-6.5.2
}

run() {
	# run with qemu
	
}

main() {
	# build
	run
}

main


#!/bin/bash

download_bootstrap() {
    
}

build_with_bootstrap() {

}

main() {
    download_bootstrap
    build_with_bootstrap
}

main


#!/bin/bash

build() {
    wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
    tar -xf busybox-1.36.1.tar.bz2

    cd busybox-1.36.1
    make defconfig

    sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
    make -j $(nproc)

    mkdir -p vfs
    make CONFIG_PREFIX=./vfs/ install

    cd vfs
    echo init << EOF
#!/bin/sh
echo "Launching Shell.."
exec /bin/sh
EOF

    find . | cpio -o -H newc > vfs.img
}

add_dirs() {
    cd vfs
    mkdir -p proc dev sys
    echo init << EOF
#!/bin/sh

echo "Mounting proc filesystem..."
mount -t proc proc /proc
if [ $? -ne 0 ]; then
    echo "Failed to mount proc filesystem."
    exit 1
fi

echo "Mounting sysfs..."
mount -t sysfs none /sys
if [ $? -ne 0 ]; then
    echo "Failed to mount sysfs."
    exit 1
fi

echo "Mounting sysfs..."
mount -t sysfs none /sys
if [ $? -ne 0 ]; then
    echo "Failed to mount sysfs."
    exit 1
fi

echo "Launching Shell.."
exec /bin/sh
EOF
}

run() {
    
}