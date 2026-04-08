# Deploying to Dokku

This guide covers deploying the aircraft monitor to a Dokku server.

## Prerequisites

- A Dokku server with Docker
- The [Flight Finder API](https://github.com/grega/flight-finder) accessible from the server

## Server setup

On your Dokku server, create the app and configure it as a worker process (no web port or health checks):

```bash
dokku apps:create aircraft-monitor
dokku checks:disable aircraft-monitor
dokku ps:scale aircraft-monitor web=0 worker=1
```

Set the environment variables:

```bash
dokku config:set aircraft-monitor \
  API_ENDPOINT="https://your-flight-finder-url" \
  API_TOKEN="your_token" \
  LATITUDE="xx.xxxx" \
  LONGITUDE="xx.xxxx" \
  RADIUS_KM=50 \
  POLL_INTERVAL=30 \
  LOW_ALTITUDE_THRESHOLD_M=1000 \
  TARGET_AIRCRAFT_CODE="A400" \
  ALERT_CHANNELS="ntfy" \
  NTFY_URL="https://ntfy.your-domain.com" \
  NTFY_TOPIC="aircraft-alerts" \
  NTFY_TOKEN="your_ntfy_token" \
  ALERT_DISTANCE_THRESHOLD_KM=25 \
  ALERT_TIME_THRESHOLD_MIN=5 \
  ALERT_ALTITUDE_THRESHOLD_M=500
```

See `.env.example` for all available options. Add `POSTMARK_API_TOKEN`, `ALERT_EMAIL_FROM`, and `ALERT_EMAIL_TO` if using email alerts.

## Deploy

From your local machine:

```bash
git remote add dokku dokku@your-server:aircraft-monitor
git push dokku main
```

## Verify

```bash
# Check the worker is running
dokku ps:report aircraft-monitor

# View logs (follow mode)
dokku logs aircraft-monitor -t
```

## Updating

Push new changes:

```bash
git push dokku main
```

## Updating config

```bash
dokku config:set aircraft-monitor KEY=value
```

This automatically restarts the worker.
