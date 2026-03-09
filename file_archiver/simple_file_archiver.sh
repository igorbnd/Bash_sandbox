#!/bin/bash

# ==== Simple script that moves a particular file to aother specified directory ====

# === Configuration - change paths as per your need ===
SOURCE="/Users/your_username/downloads/your_file.pdf"
DEST_DIR="/Users/your_username/documents/file_archive"

DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H%M")

mkdir -pv "$DEST_DIR"

if [ -f "$DEST_DIR/log.txt" ]; then
    echo "log.txt already exists in the target directory"
else
    touch "$DEST_DIR/log.txt"
    echo "log.txt file has been created"
fi

if [ -f "$SOURCE" ]; then
    mv -v "$SOURCE" "$DEST_DIR/your_file_${DATE}_${TIME}.pdf"
    MSG="✅ File found and moved to archive as your_file_${DATE}_${TIME}.pdf"
    echo "$DATE, $TIME: one file moved to archive directory: $DEST_DIR" >> "$DEST_DIR/log.txt"
else
    MSG="ℹ️ No file your_file.pdf was found in Downloads today."
    echo "$DATE, $TIME: no file moved to archive directory: $DEST_DIR" >> "$DEST_DIR/log.txt"
fi

# for macOS notification
osascript -e "display notification \"$MSG\" with title \"File Archiver\""
