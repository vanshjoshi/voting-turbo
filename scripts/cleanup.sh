#!/bin/bash
set -e

APP_NAME="next-app"
APP_DIR="/var/www/voting-app"

echo "🔹 Cleanup started..."

# 1. Check if PM2 app is running → stop it
if command -v pm2 >/dev/null 2>&1; then
  if pm2 describe $APP_NAME > /dev/null 2>&1; then
    echo "App is running → stopping..."
    pm2 stop $APP_NAME || true
    pm2 delete $APP_NAME || true
  else
    echo "App not running"
  fi
else
  echo "PM2 not installed"
fi

# 2. Check if directory exists
if [ -d "$APP_DIR" ]; then
  echo "Directory exists → cleaning..."

  # 🔥 Delete everything including hidden files
  rm -rf ${APP_DIR:?}/* ${APP_DIR}/.[!.]* ${APP_DIR}/..?* || true

else
  echo "Directory not found → creating..."
  mkdir -p "$APP_DIR"
fi

echo "✅ Cleanup completed"
