#!/bin/bash
set -euo pipefail

# This script updates Ubuntu packages and cleans up unnecessary files.
# Notifications can be sent to Telegram and/or Discord (you need to add respective credentials to the enviroment variables)
# It is intended to be run as a cron job every day at X AM to ensure the system stays up-to-date and secure.
# To set up the cron job, you can add the following line to your crontab (using `crontab -e`):
# 0 4 * * * /path/to/ubuntu_update.sh >> /var/log/ubuntu_update.log 2>&1
# Make sure to replace /path/to/ubuntu_update.sh with the actual path to this script.
# Note: This script requires sudo privileges to run, so ensure that the user running the cron job has the necessary permissions.
# The script will update the package lists, upgrade installed packages, and then clean up any unnecessary packages and files to free up disk space.
# Example usage:
# 1. Save this script as ubuntu_update.sh and make it executable:
#    chmod +x ubuntu_update.sh
# 2. Run the script manually to test it:
#    ./ubuntu_update.sh
# After confirming it works, set up the cron job as described above to automate the process.
# The script uses the following commands:
# - `sudo apt update -y`: Updates the package lists for upgrades and new packages.
# - `sudo apt upgrade -y`: Upgrades all installed packages to their latest versions.
# - `sudo apt autoclean -y`: Removes packages that can no longer be downloaded and
#   are largely useless.
# - `sudo apt autoremove --purge -y`: Removes packages that were automatically installed to satisfy dependencies for other packages and are now no longer needed, along with their configuration files.
# By keeping the system updated and clean, you can help ensure better performance and security for your Ubuntu system.
# Note: Always review and test scripts that run with sudo privileges to avoid unintended consequences.
# For more information on managing packages with apt, you can refer to the official Ubuntu documentation:
# https:#help.ubuntu.com/lts/serverguide/apt.html
# For more information on setting up cron jobs, you can refer to the official Ubuntu documentation:
# https:#help.ubuntu.com/lts/serverguide/cron.html

# --- CONFIGURATION ---
TELEGRAM_TOKEN="your_bot_token_here"
TELEGRAM_CHAT_ID="your_chat_id_here"
DISCORD_WEBHOOK_URL="your_webhook_url_here"
HOSTNAME=$(hostname)


# --- NOTIFICATION FUNCTION ---
send_notification() {
    local message="$1"
    # Telegram
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
         -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$message" > /dev/null
    # Discord
    curl -s -H "Content-Type: application/json" -X POST \
         -d "{\"content\": \"$message\"}" "$DISCORD_WEBHOOK_URL" > /dev/null
}

echo "=== Updating Ubuntu Packages on $HOSTNAME ==="
echo "Update started at: $(date)"
echo "This may take a few minutes..."

# Notify Start
send_notification "$(date) -- 🚀 Update started on $HOSTNAME"

apt update -y
apt upgrade -y
echo "Ubuntu packages updated successfully."

apt autoclean -y
apt autoremove --purge -y
echo "Cleaned up unnecessary packages and files."

# Reboot Check
if [ -f /var/run/reboot-required ]; then # Check if a reboot is required after the update and cleanup processes. If the file /var/run/reboot-required exists, it indicates that a reboot is necessary to apply the updates fully.
    send_notification "$(date) -- ⚠️ Rebooting $HOSTNAME to apply updates..."
    shutdown -r +1
else
    send_notification "$(date) -- ✅ $HOSTNAME updated successfully. No reboot needed."
fi

echo "Finished at: $(date)"
