#!/usr/bin/env bash
set -euo pipefail

# DNSfilter is not provided by the official OpenWrt feeds.
dnsfilter_dir=package/luci-app-dnsfilter
git init "$dnsfilter_dir"
git -C "$dnsfilter_dir" remote add origin https://github.com/kiddin9/luci-app-dnsfilter.git
git -C "$dnsfilter_dir" fetch --depth 1 origin 3a49542e566d8a95cb81b664a05aae29e1f534cf
git -C "$dnsfilter_dir" checkout --detach FETCH_HEAD