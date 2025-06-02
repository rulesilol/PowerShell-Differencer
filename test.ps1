$computerName = $env:COMPUTERNAME

foreach ($computer in $computerName) {
    Write-Host $computer
}