#!/bin/bash
CRUMB=$(curl -s http://jenkins:8080/jenkins/crumbIssuer/api/json -u admin:admin | python3 -c 'import sys,json; print(json.load(sys.stdin)["crumb"])')
COOKIE=$(curl -s -D- http://jenkins:8080/jenkins/crumbIssuer/api/json -u admin:admin 2>&1 | grep -i set-cookie | head -1 | cut -d' ' -f2 | tr -d '\r')

echo "CRUMB: [$CRUMB]"
echo "COOKIE: [$COOKIE]"
echo ""
echo "=== TRIGGERING BUILD ==="
curl -v -X POST "http://jenkins:8080/jenkins/job/run-playwright-script/buildWithParameters?SCRIPT_PATH=dashboard.spec.ts&BROWSER=chromium" -u admin:admin -H "Jenkins-Crumb: ${CRUMB}" -H "Cookie: ${COOKIE}" 2>&1