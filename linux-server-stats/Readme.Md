# linux-server-stats

A simple Bash script (`server-stats.sh`) to analyse basic performance stats on any Linux server.

Built as part of the [roadmap.sh](https://roadmap.sh/projects/server-stats) DevOps projects track.

## What it does

The script prints:

**Required stats**
- Total CPU usage
- Total memory usage (Free vs Used, with percentage)
- Total disk usage (Free vs Used, with percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

**Stretch stats**
- Uptime & load average
- OS version
- Logged in users
- Failed login attempts (requires `sudo`)

## Requirements

- Any Linux server/distro (uses standard tools: `top`, `free`, `df`, `ps`, `uptime`, `who`, `lastb`)
- Bash shell

## Usage

Clone the repo and make the script executable:

```bash
git clone https://github.com/<your-username>/linux-server-stats.git
cd linux-server-stats
chmod +x server-stats.sh
```

Run it:

```bash
./server-stats.sh
```

To also see failed login attempts, run with `sudo` (this section requires root access to read `/var/log/btmp`):

```bash
sudo ./server-stats.sh
```

## Example Output

```
=== Server Performance Stats ===

--- CPU Usage ---
CPU Usage: 12.30%

--- Memory Usage ---
Used: 2140MB / 7930MB (26.98%)
Free: 3200MB

--- Disk Usage ---
Used: 20G / 50G (42%)
Free: 28G

--- Top 5 Processes by CPU Usage ---
  PID COMMAND         %CPU
 1234 chrome          15.2
  567 node             8.4
  ...

--- Top 5 Processes by Memory Usage ---
  PID COMMAND         %MEM
 1234 chrome          12.3
  567 node             6.1
  ...

--- Uptime & Load Average ---
up 3 days, 2 hours
Load Average: 1.99, 1.76, 1.56

--- OS Version ---
Ubuntu 22.04.3 LTS

--- Logged In Users ---
2
ahmed    pts/0        2026-09-15 10:12 (192.168.1.5)
root     pts/1        2026-09-15 11:30 (192.168.1.8)

--- Failed Login Attempts ---
Run this script with sudo to see failed login attempts.
```

## Notes

- Memory "used" figures may look higher than expected because Linux caches aggressively (`buff/cache`); this is normal and not a problem.
- Load average should be interpreted relative to the number of CPU cores (`nproc`). A load equal to the core count means the CPU is fully busy with no processes waiting.
- A high failed-login count on `lastb` can indicate a brute-force attempt against SSH — consider `fail2ban`, disabling password auth, or disabling root login if this number is unexpectedly large.

## Author

Noor Elahi
