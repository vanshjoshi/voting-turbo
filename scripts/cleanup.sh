#!/bin/bash
set -e

APP_NAME="next-app"
APP_DIR="/home/ec2-user/app"

echo "🔹 Cleanup started..."
echo "User: $(whoami)"

# Stop PM2 app safely
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

# Handle directory
if [ -d "$APP_DIR" ]; then
  echo "Directory exists → cleaning..."
  rm -rf ${APP_DIR:?}/* ${APP_DIR}/.[!.]* ${APP_DIR}/..?* || true
else
  echo "Directory not found → creating..."
  mkdir -p "$APP_DIR"
fi

# Fix permissions
chown -R ec2-user:ec2-user $APP_DIR || true

echo "✅ Cleanup completed"
