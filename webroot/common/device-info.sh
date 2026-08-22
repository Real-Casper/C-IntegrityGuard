#!/system/bin/sh

# Specify the current root directory for both normal and update path
if [ -d "/data/adb/modules_update/CIntegrityGuard" ]; then
  BASE_PATH="/data/adb/modules_update/CIntegrityGuard"
else
  BASE_PATH="/data/adb/modules/CIntegrityGuard"
fi

INFO_DIR="$BASE_PATH/webroot/json"
mkdir -p "$INFO_DIR" 2>/dev/null
INFO_PATH="$INFO_DIR/device-info.json"

gp() { getprop "$1" 2>/dev/null; }
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

android_ver=$(gp ro.build.version.release)
kernel_ver=$(uname -r)

# Root Implementation
if [ -d "/data/adb/magisk" ] && [ -f "/data/adb/magisk.db" ]; then
  root_type="Magisk"
elif [ -f "/data/apatch/apatch" ]; then
  root_type="Apatch"
elif [ -d "/data/adb/ksu" ] && { [ -d "/data/adb/kpm" ] || [ -f "/data/adb/ksu/.dynamic_sign" ]; }; then
  root_type="SukiSU-Ultra"
elif [ -d "/data/adb/ksu" ] && { [ -f "/data/adb/ksud" ] || [ -f "/sys/module/kernelsu/parameters/expected_manager_size" ]; }; then
  root_type="KernelSU-Next"
elif [ -d "/data/adb/ksu" ]; then
  root_type="KernelSU"
else
  root_type="Unknown"
fi

# ROM sign = build tags + build type (what apps read to judge genuineness)
rom_sign="$(gp ro.build.tags) · $(gp ro.build.type)"
[ "$rom_sign" = " · " ] && rom_sign="Unknown"

# Security patch: prefer the value Tricky Store reports
sec_patch=""
if [ -f /data/adb/tricky_store/security_patch.txt ]; then
  sec_patch=$(grep -m1 . /data/adb/tricky_store/security_patch.txt 2>/dev/null)
fi
[ -z "$sec_patch" ] && sec_patch=$(gp ro.build.version.security_patch)
[ -z "$sec_patch" ] && sec_patch="Unknown"

# SELinux mode as seen now
selinux=$(getenforce 2>/dev/null)
[ -z "$selinux" ] && selinux="Unknown"

# TEE status (Tricky Store writes this; target_txt.sh depends on it)
tee_status="Unknown"
if [ -f /data/adb/tricky_store/tee_status ]; then
  tb=$(grep -E '^teeBroken=' /data/adb/tricky_store/tee_status | cut -d'=' -f2 | tr -d ' \r')
  if [ "$tb" = "false" ]; then
    tee_status="OK"
  elif [ "$tb" = "true" ]; then
    tee_status="Broken"
  fi
fi

# Keybox presence + last update date
keybox_status="Missing"
KB=/data/adb/tricky_store/keybox.xml
if [ -s "$KB" ]; then
  kb_date=$(stat -c %y "$KB" 2>/dev/null | cut -d' ' -f1)
  if [ -n "$kb_date" ]; then
    keybox_status="Installed · $kb_date"
  else
    keybox_status="Installed"
  fi
fi

# Which PIF module is active
PIF_PROP="/data/adb/modules/playintegrityfix/module.prop"
pif_name="Not found"
if [ -f "$PIF_PROP" ]; then
  n=$(grep '^name=' "$PIF_PROP" | cut -d'=' -f2-)
  case "$n" in
    *INJECT*|*Inject*) pif_name="PIF Inject" ;;
    *Fork*)            pif_name="PIF Fork" ;;
    "")                pif_name="Installed" ;;
    *)                 pif_name="$n" ;;
  esac
fi

# HMA-oss app + config state
hma_status="Not installed"
if pm list packages 2>/dev/null | grep -q org.frknkrc44.hma_oss; then
  if [ -f /data/user/0/org.frknkrc44.hma_oss/files/config.json ]; then
    hma_status="Active"
  else
    hma_status="No config"
  fi
fi

# Zygisk Next version
ZN_PROP="/data/adb/modules/zygisksu/module.prop"
zn_ver="Not found"
if [ -f "$ZN_PROP" ]; then
  zn_ver=$(grep '^version=' "$ZN_PROP" | cut -d'=' -f2 | cut -d' ' -f1)
  [ -z "$zn_ver" ] && zn_ver="Installed"
fi

# Fingerprint (kept full in JSON; UI truncates visually)
fp=$(gp ro.bootimage.build.fingerprint)
[ -z "$fp" ] && fp=$(gp ro.build.fingerprint)
[ -z "$fp" ] && fp="Unknown"

cat <<EOF > "$INFO_PATH"
{
  "android": "$(esc "$android_ver")",
  "kernel": "$(esc "$kernel_ver")",
  "root": "$(esc "$root_type")",
  "romSign": "$(esc "$rom_sign")",
  "securityPatch": "$(esc "$sec_patch")",
  "selinux": "$(esc "$selinux")",
  "teeStatus": "$tee_status",
  "keybox": "$(esc "$keybox_status")",
  "pif": "$(esc "$pif_name")",
  "hma": "$(esc "$hma_status")",
  "zygiskNext": "$(esc "$zn_ver")",
  "fingerprint": "$(esc "$fp")"
}
EOF
