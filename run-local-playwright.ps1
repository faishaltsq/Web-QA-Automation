$ErrorActionPreference = "Continue"
Push-Location "C:\Users\faishaltsq\Documents\Kerjaan\WebQA\Automation Kantorku"

Write-Host "Running Playwright test locally..."
Write-Host "================================"

# Check playwright installation
Write-Host "`nChecking Playwright installation..."
& npx playwright --version

# Run test
Write-Host "`nRunning test: course-crud.spec.ts"
Write-Host "-----------------------------------"

$env:BASE_URL = "https://hris-staging.kantorku.id/"
$env:USER_EMAIL = "risa.stagingtest@gmail.com"
$env:USER_PASSWORD = "stgtest123!"
$env:COMPANY_NAME = "PT RISA STAGING"

$testCmd = "npx playwright test tests/learning-course/course-crud.spec.ts --project=chromium --reporter=list"

try {
    Invoke-Expression $testCmd 2>&1 | Tee-Object -Variable output
} catch {
    Write-Host "Error running test: $_"
}

Pop-Location

# Save output
$output | Out-File -FilePath "C:\Users\faishaltsq\Documents\Kerjaan\WebQA\playwright-local-run.txt" -Encoding utf8
Write-Host "`nFull output saved to: C:\Users\faishaltsq\Documents\Kerjaan\WebQA\playwright-local-run.txt"