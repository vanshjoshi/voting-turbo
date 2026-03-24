#!/bin/bash
set -e

APP_NAME="next-app"
APP_DIR="/home/ec2-user/app"

echo "🔹 Deployment started..."
echo "User: $(whoami)"

cd $APP_DIR || exit 1

# Ensure permissions (important)
chown -R ec2-user:ec2-user $APP_DIR || true

echo "Installing dependencies..."
npm ci

echo "Building Next.js app..."
cd apps/web || exit 1
npm run build

echo "Starting app with PM2..."

pm2 delete $APP_NAME || true
pm2 start npm --name "$APP_NAME" -- start

pm2 save

echo "App status:"
pm2 list

echo "✅ Deployment completed successfully"
