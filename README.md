# CM520-79F OpenWrt Firmware

This repository builds a ready-to-flash OpenWrt 25.12 firmware image for the
MobiPromo CM520-79F (`ipq40xx/generic`). It uses the official
[OpenWrt 25.12 branch](https://github.com/openwrt/openwrt/tree/openwrt-25.12)
and official OpenWrt feeds only.

## Included Configuration

The source configuration is
[Config_Files/CM520_OpenWrt_25.12.config](Config_Files/CM520_OpenWrt_25.12.config).
It selects the CM520-79F device and includes LuCI, HTTPS support,
`dnsmasq-full`, `block-mount`, and USB storage support.

The post-configuration script
[DIY/cm520-openwrt-post-config.sh](DIY/cm520-openwrt-post-config.sh) changes
the default router address to `172.16.0.1`, changes the hostname to
`CM520-79F`, sets DNS cache values, and raises the connection tracking limit.
The pre-feed script intentionally adds no third-party package source; this
avoids replacing OpenWrt core packages with unpinned external code.

## Continuous Delivery

The [CM520 workflow](.github/workflows/cm520-openwrt-25.12.yml) runs when its
configuration, scripts, or workflow file changes on `main`, and can also be
started from the GitHub Actions page with **Run workflow**. It performs these
steps:

1. Installs build dependencies on Ubuntu 24.04.
2. Clones `openwrt/openwrt` at the `openwrt-25.12` branch.
3. Updates and installs official feeds, applies the configuration, and runs
	`make defconfig`.
4. Downloads sources, builds firmware, and requires a nonempty CM520-79F
	`sysupgrade.bin` image before publishing anything.
5. Uploads the complete `ipq40xx/generic` output as an Actions artifact and
	updates the `cm520-79f-openwrt-25.12` GitHub release.

The Actions artifact named `CM520-79F_OpenWrt-25.12_firmware` contains the
firmware files and checksums. The rolling GitHub release contains the same
ready-to-flash files. A separate resolved configuration artifact records the
exact symbols selected by `make defconfig`.

## Flashing

1. Download `*cm520-79f-squashfs-sysupgrade.bin` and `sha256sums` from the
	successful workflow artifact or the matching GitHub release.
2. Verify the checksum with `sha256sum -c sha256sums` on Linux or WSL. On
	PowerShell, compare `Get-FileHash <image> -Algorithm SHA256` with the entry
	for the image in `sha256sums`.
3. Back up the existing CM520-79F configuration before upgrading.
4. Use LuCI's **Flash image** page or run `sysupgrade <image>` over SSH.
5. Keep configuration only when its packages and settings are compatible with
	OpenWrt 25.12. A clean configuration is recommended for a major upgrade.

Never flash an image intended for a different `ipq40xx` device. Interrupting
power while firmware is being written can make the router unbootable.

## Local Build

Use a supported Linux host or WSL distribution with Bash. Run the following
from a clean clone:

```bash
git clone --depth 1 --branch openwrt-25.12 https://github.com/openwrt/openwrt.git
cd openwrt
bash ../path-to-this-repository/DIY/cm520-openwrt-pre-feeds.sh
./scripts/feeds update -a
./scripts/feeds install -a
cp ../path-to-this-repository/Config_Files/CM520_OpenWrt_25.12.config .config
bash ../path-to-this-repository/DIY/cm520-openwrt-post-config.sh
make defconfig
make download -j"$(nproc)"
make -j"$(nproc)"
```

The flashable image is written to
`bin/targets/ipq40xx/generic/*cm520-79f-squashfs-sysupgrade.bin`.
