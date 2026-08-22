MODPATH="${0%/*}"

# Leave busybox ash standalone mode if we happen to be in it.
# Guarded: plain /system/bin/sh (mksh) has no such option and would abort here.
set +o standalone 2>/dev/null || true
unset ASH_STANDALONE

for SCRIPT in \
  "kill_google_process.sh" \
  "target_txt.sh" \
  "security_patch.sh" \
  "boot_hash.sh" \
  "keybox.sh"
do
  if ! sh "$MODPATH/Core/$SCRIPT"; then
    echo "- Error: $SCRIPT failed. Aborting..."
    exit 1
  fi
done
  sh "$MODPATH/Core/pif.sh"

if [ -f /data/adb/modules_update/CIntegrityGuard/webroot/common/device-info.sh ]; then
  sh /data/adb/modules_update/CIntegrityGuard/webroot/common/device-info.sh
elif [ -f /data/adb/modules/CIntegrityGuard/webroot/common/device-info.sh ]; then
  sh /data/adb/modules/CIntegrityGuard/webroot/common/device-info.sh
fi

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with C-IntegrityGuard✨✨"