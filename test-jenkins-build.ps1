$b = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:admin"))
$baseHeaders = @{"Authorization" = "Basic $b"}

try {
    # Step 1: Get cookies and crumb
    $cookieResponse = Invoke-WebRequest -Uri "http://localhost:8080/jenkins/crumbIssuer/api/json" -Headers $baseHeaders -UseBasicParsing
    $crumbJson = $cookieResponse.Content | ConvertFrom-Json

    # Get all cookies from crumb response
    $allCookies = $cookieResponse.Headers["Set-Cookie"]
    Write-Host "All Cookies: $allCookies"

    # Parse cookies into name=value pairs
    $cookiePairs = @()
    if ($allCookies) {
        $cookies = $allCookies -split ","
        foreach ($c in $cookies) {
            $parts = $c -split ";"
            $cookiePairs += $parts[0].Trim()
        }
    }
    $cookieHeader = $cookiePairs -join "; "
    Write-Host "Cookie Header: $cookieHeader"

    # Step 2: Trigger build with crumb and cookies
    $buildHeaders = @{
        "Authorization" = "Basic $b"
        $crumbJson.crumbRequestField = $crumbJson.crumb
        "Cookie" = $cookieHeader
    }

    $params = @{
        "SCRIPT_PATH" = "/data/automation/tests/demo-todo.spec.ts"
        "BROWSER" = "chromium"
        "BASE_URL" = "http://nextjs:3000"
    }
    $query = ($params.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"

    $buildUri = "http://localhost:8080/jenkins/job/run-playwright-script/buildWithParameters?$query"
    Write-Host "Calling: $buildUri"

    $buildResponse = Invoke-WebRequest -Uri $buildUri -Method POST -Headers $buildHeaders -UseBasicParsing
    Write-Host "Response Status: $($buildResponse.StatusCode)"
    Write-Host "Location: $($buildResponse.Headers.Location)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}