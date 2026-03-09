#!/bin/bash
set -euo pipefail

# ==== Simple script that moves a particular file to aother specified directory and logging in log.txt ====

# === Configuration - change paths as per your need ===
FILENAME="your_file"
SOURCE="/Users/your_username/downloads/${FILENAME}"
DEST_DIR="/Users/your_username/documents/file_archive"

FILENAME="${SOURCE##*/}"
EXT="${FILENAME##*.}"
BASENAME="${FILENAME%.*}"

TIMESTAMP=$(date +"%Y-%m-%d_%H%M")
DATE="${TIMESTAMP%%_*}"

mkdir -pv "$DEST_DIR"

if [ -f "$DEST_DIR/log.txt" ]; then
    echo "log.txt already exists in the target directory"
else
    touch "$DEST_DIR/log.txt"
    echo "log.txt file has been created"
fi

if [ -f "$SOURCE" ]; then
    mv -v "$SOURCE" "$DEST_DIR/${BASENAME}_${TIMESTAMP}.${EXT}"
    MSG="✅ File found and moved to archive as ${BASENAME}_${TIMESTAMP}.${EXT}"
    echo "$TIMESTAMP: one file moved to archive directory: $DEST_DIR" >> "$DEST_DIR/log.txt"
else
    MSG="ℹ️ No file ${FILENAME} was found in the source directory today."
    echo "$TIMESTAMP: no file moved to archive directory: $DEST_DIR" >> "$DEST_DIR/log.txt"
fi

# macOS notification (skipped if osascript is unavailable)
command -v osascript &>/dev/null && osascript -e "display notification \"$MSG\" with title \"File Archiver\""
