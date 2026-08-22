#!/system/bin/sh

# Define important paths and file names
TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/Real-Casper/C-IntegrityGuard/main/key"
REMOTE_FILE="$TRICKY_DIR/keybox"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
DECODE_FILE="$TRICKY_DIR/keybox_decode"
DEPENDENCY_MODULE="/data/adb/modules/tricky_store"
DEPENDENCY_MODULE_UPDATE="/data/adb/modules_update/tricky_store"
BBIN="/data/adb/CIntegrityGuard/bin"
ORG_PATH="$PATH"

# Show UI banner
ui_print ""
ui_print "*********************************"
ui_print "****C-IntegrityGuard Setup*******"
ui_print "*********************************"
ui_print ""

# Remove old modules if legacy paths exist (previous 'Yurikey' / 'yurikey' installs)
if [ -d "/data/adb/modules/yurikey" ]; then
  touch /data/adb/modules/yurikey/remove
fi
if [ -d "/data/adb/modules/Yurikey" ]; then
  touch /data/adb/modules/Yurikey/remove
fi

# Check if Tricky Store module is installed (required dependency)
if [ ! -d "$DEPENDENCY_MODULE_UPDATE" ] && [ ! -d "$DEPENDENCY_MODULE" ]; then
  ui_print "- Error: Tricky Store module file not found!"
  ui_print "- Please install Tricky Store before using this module."
  return 0
fi

# A few wipes
if [ -d "$BBIN" ]; then
  rm -rf $BBIN
fi

download() {
    PATH=/data/adb/magisk:/data/data/com.termux/files/usr/bin:$PATH
    if command -v curl >/dev/null 2>&1; then
        curl --connect-timeout 10 -Ls "$1"
    else
        busybox wget -T 10 --no-check-certificate -qO- "$1"
    fi
    PATH="$ORG_PATH"
}

# Function to download the remote keybox
get_keybox() {
    download "$REMOTE_URL" > "$REMOTE_FILE" || ui_print "Error: Keybox download failed, please add keybox manually!"

    if ! base64 -d "$REMOTE_FILE" > "$DECODE_FILE" 2>/dev/null; then
        ui_print "- Error: Base64 decode failed!"
        return 1
    fi
    return 0
}

# Function to update the keybox file
update_keybox() {
  ui_print "- Fetching remote keybox..."
  if ! get_keybox; then
    ui_print "- Failed to fetch keybox!"
    return
  fi

  # Check if keybox already exists
  if [ -f "$TARGET_FILE" ]; then
    # If the new one is identical, skip update
    if cmp -s "$TARGET_FILE" "$DECODE_FILE"; then
      ui_print "- Existing keybox is already up to date. No changes made."
      rm -f "$REMOTE_FILE"
      return
    else
      # If the file differs, back up the old one
      ui_print "- Existing keybox differs from the bundled one."
      ui_print "- Creating a backup keybox..."
      mv "$TARGET_FILE" "$BACKUP_FILE"
      mv "$DECODE_FILE" "$TARGET_FILE"
    fi
  else
    ui_print "- No keybox found! Creating a new one..."
    mv "$DECODE_FILE" "$TARGET_FILE"
    rm -f "$REMOTE_FILE"
  fi
}
# Start main logic
ui_print "- Checking for an existing keybox..."
mkdir -p "$TRICKY_DIR" # Make sure the directory exists
update_keybox          # Begin the update process

# Run bundled device-info.sh if present (already verified)
DEVICE_INFO_SCRIPT="$TMPDIR/webroot/common/device-info.sh"
if [ -f "$DEVICE_INFO_SCRIPT" ]; then
  sh "$DEVICE_INFO_SCRIPT"
else
  # fallback: run already-installed one
  if [ -f /data/adb/modules_update/CIntegrityGuard/webroot/common/device-info.sh ]; then
    sh /data/adb/modules_update/CIntegrityGuard/webroot/common/device-info.sh
  elif [ -f /data/adb/modules/CIntegrityGuard/webroot/common/device-info.sh ]; then
    sh /data/adb/modules/CIntegrityGuard/webroot/common/device-info.sh
  fi
fi
