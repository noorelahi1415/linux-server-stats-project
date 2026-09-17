# nginx-log-analyser

A simple Bash CLI tool to analyze Nginx access logs and report key traffic statistics.

Built as part of the [roadmap.sh](https://roadmap.sh/projects/nginx-log-analyser) DevOps projects track.

## What it does

Parses a standard Nginx access log (combined log format) and reports:

- Top 5 IP addresses with the most requests
- Top 5 most requested paths
- Top 5 response status codes
- Top 5 user agents

## Requirements

- Any Linux/Unix system with Bash
- Standard tools: `awk`, `sort`, `uniq` (pre-installed on virtually every distro)
- An Nginx access log file in combined log format

## Usage

Clone the repo and make the script executable:

```bash
git clone https://github.com/<your-username>/nginx-log-analyser.git
cd nginx-log-analyser
chmod +x nginx-log-analyser.sh
```

Run it against a log file:

```bash
./nginx-log-analyser.sh access.log
```

## Example Output

```
Nginx Log Analyser
Analyzing: access.log

==============================
Top 5 IP addresses with the most requests
==============================
  45 178.128.94.113
  12 142.93.136.176
   3 86.134.118.70

==============================
Top 5 most requested paths
==============================
 234 /api/users
 187 /home
  56 /login

==============================
Top 5 response status codes
==============================
 450 200
  23 404
   5 500

==============================
Top 5 user agents
==============================
 312 Mozilla/5.0 (Windows NT 10.0; Win64; x64)
  45 curl/7.68.0
  10 DigitalOcean Uptime Probe 0.22.0
```

## Error Handling

| Scenario | Behavior |
|---|---|
| No log file argument provided | Prints usage error, exits with code 1 |
| Provided path is not a valid file | Prints error, exits with code 1 |

## How It Works (Internals)

A standard Nginx combined log line looks like:

```
178.128.94.113 - - [16/Sep/2026:14:30:12 +0000] "GET /api/users HTTP/1.1" 200 512 "-" "Mozilla/5.0"
```

- **IP address** — `awk '{print $1}'` (first space-separated field)
- **Requested path** — `awk '{print $7}'` (7th space-separated field, inside the request line)
- **Status code** — `awk '{print $9}'` (9th space-separated field)
- **User agent** — `awk -F'"' '{print $6}'` (split on double-quotes instead of spaces, since user agent strings contain spaces; the 6th quoted segment is the user agent)

Every stat follows the same pipeline:

```
awk '...' file | sort | uniq -c | sort -rn | head -5
```

1. `awk` extracts the relevant field from every line
2. `sort` groups identical values together (required before `uniq` can count them)
3. `uniq -c` collapses duplicates and counts occurrences
4. `sort -rn` sorts numerically, highest count first
5. `head -5` keeps only the top 5

## Author

Noor Elahi
