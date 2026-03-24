#!/bin/bash
set -e

APP_NAME="next-app"
APP_DIR="/var/www/voting-app"

echo "🔹 Deployment started..."

# Ensure PM2 exists
if ! command -v pm2 >/dev/null 2>&1; then
  echo "Installing PM2..."
  npm install -g pm2
fi

cd $APP_DIR

# Install only production deps (faster)
echo "Installing production dependencies..."
npm install --omit=dev

# Go to Next.js app
cd apps/web

echo "Starting app..."

pm2 describe $APP_NAME > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Restarting app..."
  pm2 restart $APP_NAME
else
  echo "Starting new app..."
  pm2 start npm --name "$APP_NAME" -- start
fi

pm2 save

echo "✅ Deployment completed"
