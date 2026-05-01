#!/bin/bash
# Get crumb
curl -s -c /tmp/cookies.txt -u admin:admin "http://localhost:8080/jenkins/crumbIssuer/api/json" > /tmp/crumb.json
CRUMB=$(cat /tmp/crumb.json | grep -o '"crumb":"[^"]*"' | cut -d'"' -f4)
echo "Using crumb: $CRUMB"

# Trigger build
curl -s -b /tmp/cookies.txt -c /tmp/cookies.txt -X POST "http://localhost:8080/jenkins/job/run-playwright-script/buildWithParameters" \
  -H "Jenkins-Crumb: $CRUMB" \
  -u admin:admin \
  --data-urlencode "SCRIPT_PATH=tests/dashboard.spec.ts" \
  --data-urlencode "BASE_URL=http://nextjs:3000" \
  --data-urlencode "BROWSER=chromium" \
  -w "\nHTTP_CODE:%{http_code}"