#!/bin/bash

SERVER_USER="sshtest"
SERVER_IP="95.111.236.78"
REMOTE_PATH="/var/www/html/"
LOCAL_PATH="./site/"

echo "Deploying static site to $SERVER_IP..."

rsync -avz --delete "$LOCAL_PATH" "$SERVER_USER@$SERVER_IP:$REMOTE_PATH"

echo "Deployment complete."
