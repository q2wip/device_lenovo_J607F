#!/vendor/bin/sh
# Copy crash tombstones to /sdcard/ for debugging
# Runs once after boot completes

src="/data/tombstones"
dst="/sdcard/tombstones"
ts=$(date +%Y%m%d-%H%M%S)

# Wait for /sdcard to be available
for i in $(seq 1 30); do
    if mountpoint -q /sdcard 2>/dev/null || [ -d /sdcard/Android ]; then
        break
    fi
    sleep 1
done

# Check if any tombstone exists
count=$(ls "$src"/tombstone_* 2>/dev/null | wc -l)
if [ "$count" -eq 0 ]; then
    echo "[tombstone_copy] No tombstones found at $ts" >> /data/tombstone_copy.log
    exit 0
fi

# Create destination
mkdir -p "$dst/$ts"

# Copy all tombstones
cp "$src"/tombstone_* "$dst/$ts/" 2>/dev/null
cp "$src"/dtobstone_* "$dst/$ts/" 2>/dev/null

# Also copy data_app_* crashes
cp /data/vendor/tombstones/*_crash_* "$dst/$ts/" 2>/dev/null

echo "[tombstone_copy] Copied $count tombstones to $dst/$ts at $ts" >> /data/tombstone_copy.log
echo "Tombstones available at $dst/$ts"
