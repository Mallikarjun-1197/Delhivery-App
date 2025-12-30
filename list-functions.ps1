# Helper script to list and test deployed functions

# Usage: .\list-functions.ps1 -BaseUrl "https://your-app.azurewebsites.net"

param (
    [string]$BaseUrl
)

if (-not $BaseUrl) {
    Write-Host "Please provide the base URL of your Function App or Static Web App." -ForegroundColor Yellow
    Write-Host "Example: .\list-functions.ps1 -BaseUrl 'https://delhivery-func.azurewebsites.net'"
    Write-Host "Example: .\list-functions.ps1 -BaseUrl 'https://calm-sea-123.azurestaticapps.net'"
    exit
}

# Remove trailing slash
if ($BaseUrl.EndsWith("/")) {
    $BaseUrl = $BaseUrl.Substring(0, $BaseUrl.Length - 1)
}

Write-Host "Targeting: $BaseUrl" -ForegroundColor Cyan
Write-Host "----------------------------------------"

# Function 1: CreateShipment
$createUrl = "$BaseUrl/api/CreateShipment"
Write-Host "1. CreateShipment (POST)" -ForegroundColor Green
Write-Host "   URL: $createUrl"
try {
    $payload = @{
        pickup_address = "123 Main St"
        delivery_address = "456 Market St"
        weight = 2.5
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri $createUrl -Method Post -Body $payload -ContentType "application/json"
    Write-Host "   ✅ Success! Response:" -ForegroundColor Cyan
    Write-Host ($response | ConvertTo-Json)
} catch {
    Write-Host "   ❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host "   Details: $($reader.ReadToEnd())" -ForegroundColor Red
    }
}

Write-Host "`n----------------------------------------"

# Function 2: Track
$trackId = "BK-1000"
$trackUrl = "$BaseUrl/api/Track/$trackId"
Write-Host "2. Track (GET)" -ForegroundColor Green
Write-Host "   URL: $trackUrl"
try {
    $response = Invoke-RestMethod -Uri $trackUrl -Method Get
    Write-Host "   ✅ Success! Response:" -ForegroundColor Cyan
    Write-Host ($response | ConvertTo-Json)
} catch {
    Write-Host "   ❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n----------------------------------------"
Write-Host "To view logs:"
Write-Host "1. Go to Azure Portal -> Function App -> Log Stream"
Write-Host "2. Or use VS Code Azure Functions extension -> Right click Function App -> Start Streaming Logs"
