#!/bin/bash

echo "=== CLEANUP START ==="

APP_DIR="/home/ec2-user/app"

# Stop running app (safe)
pm2 stop all || true
pm2 delete all || true

# Ensure directory exists
if [ ! -d "$APP_DIR" ]; then
  echo "Creating app directory..."
  mkdir -p $APP_DIR
else
  echo "Cleaning existing app directory..."
  rm -rf $APP_DIR/*
fi

echo "=== CLEANUP DONE ==="
