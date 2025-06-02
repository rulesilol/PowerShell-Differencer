$timer1 = Get-Date

$Services = Get-Service | Select-Object -Property Name

foreach ($Service in $Services) {
    $Service.Name
}

$timer2 = Get-Date
($timer2-$timer1).totalSeconds