# Check the status of the IIS (W3SVC) service
$service = Get-Service -Name 'W3SVC' -ErrorAction SilentlyContinue

if ($null -eq $service) {
    Write-Host "IIS (W3SVC) service not found." -ForegroundColor Red
} elseif ($service.Status -eq 'Running') {
    Write-Host "IIS (W3SVC) is already running." -ForegroundColor Green
} else {
    Write-Host "IIS (W3SVC) is not running. Attempting to start it..." -ForegroundColor Yellow
    try {
        Start-Service -Name 'W3SVC'
        Write-Host "IIS (W3SVC) has been started successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to start IIS (W3SVC): $_" -ForegroundColor Red
    }
}
