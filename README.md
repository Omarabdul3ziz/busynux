# BusyNux

Builds a minimal Linux from source: a kernel, a static BusyBox root filesystem packed as an initramfs, booted under QEMU. It's a learning project about what a distribution is underneath.

## How it builds

[`build.sh`](build.sh) runs these steps:

1. **BusyBox**: downloads the source, builds it as a static binary, and turns off the networking features that need extra libraries.
2. **Kernel**: downloads the kernel, builds it with `make defconfig`, and keeps `bzImage`.
3. **Root filesystem**: creates `bin dev proc sys` and links every BusyBox applet to `/bin/busybox`.
4. **Init**: copies an `init` script in as PID 1.
5. **Image**: packs the tree into an initramfs with `cpio -H newc`.

Then QEMU boots the kernel with that initramfs on a serial console:

```bash
make run   # qemu-system-x86_64 -kernel bzImage -initrd root.img -nographic -append "console=ttyS0"
```

## Status

Work in progress. The steps above are implemented but commented out in `main()` while the configurable build (`make defconfig`, root filesystem modes `example`, `busybox` and `bootstrap`) is being written. See the [usage guide](docs/guide.md).

## Docs

- [Usage guide](docs/guide.md)
- [Tutorial: how it's built](docs/tutorial.md)
- [Topics learned along the way](docs/topics.md)
- [Resources](docs/resources.md)
