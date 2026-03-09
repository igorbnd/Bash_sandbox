# File Archiver

A simple Bash script for macOS that moves a file from your Downloads folder into a date-stamped archive directory.

## What It Does

1. Creates the archive directory if it doesn't already exist.
2. Initialises a `log.txt` file in the archive directory (if one isn't already present).
3. Checks whether the source file exists in Downloads:
   - **If found** — moves it to the archive with a timestamped filename (e.g. `your_file_2026-03-09_1430.pdf`).
   - **If not found** — logs that no file was available.
4. Sends a macOS notification with the result.

The file extension is auto-detected from the source path, so the script works with any file type — `.pdf`, `.docx`, `.png`, etc.

## Setup

1. Edit the `SOURCE` and `DEST_DIR` variables at the top of the script to match your environment:
   ```bash
   SOURCE="/Users/your_username/downloads/your_file.pdf"
   DEST_DIR="/Users/your_username/documents/file_archive"
   ```
2. Make the script executable:
   ```bash
   chmod +x cv_archiver.sh
   ```
3. Run it:
   ```bash
   ./cv_archiver.sh
   ```

## Automation (Optional)

You can schedule the script to run automatically using a macOS Launch Agent or a cron job. In my case I find cron job is the easier option.

## Requirements

- macOS (uses `osascript` for native notifications; skipped gracefully on other systems)
- Bash
