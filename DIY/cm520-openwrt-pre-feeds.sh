#!/usr/bin/env bash
set -euo pipefail

# DNSfilter is not provided by the official OpenWrt feeds.
git clone --depth 1 https://github.com/kiddin9/luci-app-dnsfilter.git \
  package/luci-app-dnsfilter