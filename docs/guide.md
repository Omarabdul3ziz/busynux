## Usage guide

you can simply use make to build and run your distribution with this tool.

- To get the default configs just run
  ```bash
  make defconfig
  ```
- Once you have your `.config` file ready you can build and run distro with qemu
  ```bash
  make build
  make run
  ```

### Configurations

you can use the `make defconfig` which will create a busybox based distro, or you can customize your built either by directly edit the `.config` file or with passing envvars to `make config` command.

The configs are:

- `KERNEL_VERSION`: linux kernel version which will be used in the distro. (eg: `5.15.131`)
- `ROOTFS_MODE`: there is some variations of created rootfs you can use from each one will require extra configs:
  - `example`: this will take a simple .c program that will run after the boot.
    - `INIT_PROGRAM`: path to the .c file
  - `busybox`: this will use compile busybox and install it so you will have all the binaries also will mount some directories. and system will boot to bash shell
    - `BUSYBOX_VERSION`: which version of busybox to compile
  - `bootstrap`: this will use `debootstrap` to get full rootfs from another distro.
    - `BOOTSTRAP_DISTRO`: the distro name.
    - `BOOTSTRAP_ARCHIVE`: the distro base images archive.
    - `BOOTSTRAP_VERSION`: the distro version.
  - `scratch`: this will build all the files/directories compile the needed versions from scratch and will start the machine with `zinit` as a PID 1
