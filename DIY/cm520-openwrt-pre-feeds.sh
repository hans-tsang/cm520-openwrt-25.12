#!/usr/bin/env bash
set -euo pipefail

# DNSfilter is not provided by the official OpenWrt feeds.
dnsfilter_dir=package/luci-app-dnsfilter
git clone https://github.com/kiddin9/luci-app-dnsfilter.git "$dnsfilter_dir"
git -C "$dnsfilter_dir" checkout --detach 3a49542e566d8a95cb81b664a05aae29e1f534cf