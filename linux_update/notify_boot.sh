#!/bin/bash
set -euo pipefail

TELEGRAM_TOKEN="your_bot_token_here"
TELEGRAM_CHAT_ID="your_chat_id_here"
DISCORD_WEBHOOK_URL="your_webhook_url_here"
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)

message="$(date) -- ✅ $HOSTNAME is back online. Uptime: $UPTIME"

curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
     -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$message" > /dev/null

curl -s -H "Content-Type: application/json" -X POST \
     -d "{\"content\": \"$message\"}" "$DISCORD_WEBHOOK_URL" > /dev/null
