# CM520-79F DNSfilter Firmware

This repository builds a ready-to-flash DNSfilter firmware image for the
MobiPromo CM520-79F (`ipq40xx/generic`). Its active build follows the Canbox
configuration and DIY scripts from
[OneCloud_Canbox-OpenWrt_DNSfilter](https://github.com/2286927/OneCloud_Canbox-OpenWrt_DNSfilter).

## Included Configuration

The source configuration is
[Config_Files/CanBox.config](Config_Files/CanBox.config). It selects the
CM520-79F device, `luci-app-dnsfilter`, and `dnsmasq-full`.

The build runs [diy-part1.sh](diy-part1.sh) before updating feeds and
[diy-part2.sh](diy-part2.sh) after selecting the configuration, matching the
referenced build. These add its package sources, DNSfilter feed, default
address, hostname, DNS cache settings, and connection tracking limit.

## Continuous Delivery

The [CM520 workflow](.github/workflows/cm520-dnsfilter.yml) can be
started from the GitHub Actions page with **Run workflow**. It performs these
steps:

1. Installs build dependencies on Ubuntu 24.04.
2. Clones `coolsnowwolf/lede` at `master`.
3. Runs the referenced custom feed script, updates and installs feeds, applies
   the configuration, and runs
	`make defconfig`.
4. Downloads sources, builds firmware, and requires a nonempty CM520-79F
	`sysupgrade.bin` image before publishing anything.
5. Uploads the complete `ipq40xx/generic` output as an Actions artifact and
	updates the `cm520-79f-dnsfilter` GitHub release.

The Actions artifact named `CM520-79F_DNSfilter_firmware` contains the
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
4. In LuCI's **Flash image** page, select the
	`*cm520-79f-squashfs-sysupgrade.bin` file.
5. Alternatively, run `sysupgrade -n <image>` over SSH. The `-n` option
	explicitly starts with a clean configuration.

Never flash an image intended for a different `ipq40xx` device. Interrupting
power while firmware is being written can make the router unbootable. After
the first boot, configure the router at `172.30.1.1`.

## Local Build

Use a supported Linux host or WSL distribution with Bash. Run the following
from a clean clone:

```bash
git clone --depth 1 --branch master https://github.com/coolsnowwolf/lede.git
cd lede
bash ../path-to-this-repository/diy-part1.sh
./scripts/feeds update -a
./scripts/feeds install -a
cp ../path-to-this-repository/Config_Files/CanBox.config .config
bash ../path-to-this-repository/diy-part2.sh
make defconfig
make download -j"$(nproc)"
make -j"$(nproc)"
```

The flashable image is written to
`bin/targets/ipq40xx/generic/*cm520-79f-squashfs-sysupgrade.bin`.
