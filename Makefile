
# default values that can be overwriten by envvar
KERNEL_PATH ?= /var/lib/busynux/bzImage
IMAGE_PATH ?= /var/lib/busynux/root.img

defconfig:
	echo "Creating default config..."
	echo .config << EOF
KERNEL_VERSION=5.15.131
ROOTFS_MODE=example
INIT_PROGRAM=./init.c
BUSYBOX_VERSION=
BOOTSTRAP_DISTRO=
BOOTSTRAP_ARCHIVE=
BOOTSTRAP_VERSION=
EOF

config:

build:
	echo "Starting the build script..."
	chmod +x ./build.sh
	./build.sh

run:
	echo "Booting the vm..."
	qemu-system-x86_64 \
		-kernel $(KERNEL_PATH) \
		-initrd $(IMAGE_PATH) \
		-nographic \
		-no-reboot \
		-append "panic=1 console=ttyS0"
