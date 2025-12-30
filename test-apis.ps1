# Test Azure Static Web App APIs
# Replace with your actual Static Web App URL
$baseUrl = "https://YOUR-STATIC-WEB-APP-NAME.azurestaticapps.net"

Write-Host "Testing CreateShipment API..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/CreateShipment" -Method Post -Body '{"test": "data"}' -ContentType "application/json"
    Write-Host "✅ CreateShipment API is working!" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ CreateShipment API failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nTesting Track API..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/Track/12345" -Method Get
    Write-Host "✅ Track API is working!" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Track API failed: $($_.Exception.Message)" -ForegroundColor Red
}

