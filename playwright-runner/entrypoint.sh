#!/bin/sh

echo "========================================="
echo "Playwright Runner Container"
echo "========================================="
echo "Script: $SCRIPT_PATH"
echo "Browser: $BROWSER"
echo "Base URL: $BASE_URL"
echo "Build Number: $BUILD_NUMBER"
echo "========================================="

if [ -z "$SCRIPT_PATH" ]; then
    echo "ERROR: SCRIPT_PATH environment variable is required"
    exit 1
fi

if [ -z "$BASE_URL" ]; then
    echo "WARN: BASE_URL not set, defaulting to http://localhost:3000"
    BASE_URL="http://localhost:3000"
fi

SCRIPT_FULL_PATH="/data/automation/tests/$SCRIPT_PATH"

if [ ! -f "$SCRIPT_FULL_PATH" ]; then
    echo "ERROR: Script not found at $SCRIPT_FULL_PATH"
    exit 1
fi

cd /data/automation

BUILD_NUM="${BUILD_NUMBER:-0}"
PLAYWRIGHT_REPORT_DIR="/data/reports/playwright-html/$BUILD_NUM"
ALLURE_RESULTS_DIR="/data/reports/allure-results/$BUILD_NUM"
ALLURE_REPORT_DIR="/data/reports/allure-report/$BUILD_NUM"

rm -rf playwright-report allure-results
mkdir -p "$PLAYWRIGHT_REPORT_DIR" "$ALLURE_RESULTS_DIR" "$ALLURE_REPORT_DIR"

echo "Executing: npx playwright test $SCRIPT_FULL_PATH"
PLAYWRIGHT_JSON_OUTPUT_NAME=playwright-report/report.json \
npx playwright test "$SCRIPT_FULL_PATH" \
    --reporter=list,html,json \
    --project=chromium \
    --timeout=${TEST_TIMEOUT:-60000} || true

# Copy HTML report + JSON report to per-build folder regardless of test result
cp -r playwright-report/* "$PLAYWRIGHT_REPORT_DIR/" 2>/dev/null || true

# Copy allure results if they exist (for future use with @playwright/test allure plugin)
if [ -d "allure-results" ]; then
    cp -r allure-results/* "$ALLURE_RESULTS_DIR/" 2>/dev/null || true
fi

echo "Test run completed — report saved to $PLAYWRIGHT_REPORT_DIR"
ls -la "$PLAYWRIGHT_REPORT_DIR" 2>&1 || true