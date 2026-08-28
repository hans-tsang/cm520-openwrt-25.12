#!/usr/bin/env bash
set -euo pipefail

config_generate=package/base-files/files/bin/config_generate
dnsmasq_config=package/network/services/dnsmasq/files/dnsmasq.conf
conntrack_config=package/kernel/linux/files/sysctl-nf-conntrack.conf

sed -i 's/192.168.1.1/172.16.0.1/g' "$config_generate"
sed -i 's/OpenWrt/CM520-79F/g' "$config_generate"

cat >> "$dnsmasq_config" <<'EOF'
# Local DNS cache settings for the CM520-79F image.
neg-ttl=600
min-cache-ttl=3600
EOF

sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=165535/g' \
  "$conntrack_config"