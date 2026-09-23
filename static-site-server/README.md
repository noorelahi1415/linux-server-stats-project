# static-site-server

A static HTML/CSS website served via Nginx on a remote Linux server, deployed using an `rsync`-based `deploy.sh` script.

Built as part of the [roadmap.sh](https://roadmap.sh/projects/static-site-server) DevOps projects track.

> ⚠️ **Note:** This repository intentionally contains no real server IP address. `<server-ip>` is used as a placeholder throughout.

---

## Overview

This project sets up a basic Nginx web server on a remote Linux machine to serve a static site, and automates deployment with `rsync` so that any local change can be pushed to the server with a single command.

## Project Structure

```
static-site-server/
├── site/
│   ├── index.html
│   └── style.css
├── deploy.sh
└── README.md
```

## Prerequisites

- A remote Linux server with SSH access (see [ssh-remote-server-setup](https://github.com/noorelahi1415/ssh-remote-server-setup) for key-based access setup)
- `rsync` installed locally (pre-installed on most Linux/macOS systems)
- `sudo` privileges on the remote server for installing Nginx

## Steps

### 1. Install Nginx on the server

```bash
ssh <user>@<server-ip>
sudo apt update
sudo apt install nginx -y
```

Verified it was running:

```bash
sudo systemctl status nginx
```

### 2. Built the static site locally

```
site/
├── index.html
└── style.css
```

A simple HTML page styled with CSS — no frameworks, just plain HTML/CSS to satisfy the project requirement.

### 3. Wrote `deploy.sh`

```bash
#!/bin/bash

SERVER_USER="<user>"
SERVER_IP="<server-ip>"
REMOTE_PATH="/var/www/roadmap-static/"
LOCAL_PATH="./site/"

echo "Deploying static site to $SERVER_IP..."

rsync -avz --delete "$LOCAL_PATH" "$SERVER_USER@$SERVER_IP:$REMOTE_PATH"

echo "Deployment complete."
```

- `-a` (archive) preserves permissions, timestamps, and directory structure
- `-v` (verbose) shows which files are transferred
- `-z` compresses data in transit
- `--delete` removes files on the server that no longer exist locally, keeping both sides in sync

### 4. Configured a dedicated Nginx server block on a custom port

Because the target server already runs a production application on the default port, a **separate server block on a non-default port** was used instead of overwriting the default site — keeping this exercise fully isolated from the existing production workload.

```bash
sudo mkdir -p /var/www/roadmap-static
sudo chown -R <user>:<user> /var/www/roadmap-static
```

`/etc/nginx/sites-available/roadmap-static`:

```nginx
server {
    listen 8081;
    server_name _;

    root /var/www/roadmap-static;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Enabled the site and reloaded Nginx without downtime:

```bash
sudo ln -s /etc/nginx/sites-available/roadmap-static /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

- `nginx -t` validates the config syntax before it's applied — catches mistakes before they can affect the running server
- `systemctl reload` applies the new config without restarting Nginx, avoiding any interruption to existing sites

### 5. Deployed the site

```bash
./deploy.sh
```

Verified in the browser:

```
http://<server-ip>:8081
```

## Issues Encountered & Fixes

### 1. `sshtest is not in the sudoers file`
The deployment user had no `sudo` privileges by default.

**Fix:**
```bash
# as root
usermod -aG sudo <user>
```
Logged out and back in for the group change to take effect.

### 2. `rsync: Permission denied` on `/var/www/html/`
Initially attempted to deploy directly into Nginx's default web root, which was owned by `root` — and which also hosted the existing production site, making it the wrong target entirely.

**Fix:** Instead of forcing permissions onto the shared default root, created a completely separate directory (`/var/www/roadmap-static`) owned by the deployment user, and served it through its own Nginx server block on a dedicated port (`8081`) — avoiding any risk to the production application already running on the server.

## Outcome

- ✅ Remote server accessible via SSH
- ✅ Nginx installed and configured to serve a static site
- ✅ Simple HTML/CSS webpage created
- ✅ `deploy.sh` automates syncing local changes to the server via `rsync`
- ✅ Site isolated from the server's existing production workload using a dedicated port and directory

## Author

Noor Elahi
