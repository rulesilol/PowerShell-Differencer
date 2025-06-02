$rootHash = @{
    "Andrew-PC" = [System.Collections.ArrayList]@(("Open-Ports", "4252"), ("Open-Ports", "445"))
    "My-PC2" = [System.Collections.ArrayList]@(("Open-Ports", "121"), ("Open-Ports", "883"))
}


$newArray = ("Open-Ports", "445"), ("Open-Ports", "5263")

# $Comparison = ($rootHash['My-PC1'] | Compare-Object $newArray) 

$Comparison = Compare-Object -DifferenceObject $newArray -ReferenceObject $rootHash[$env:COMPUTERNAME]

foreach ($item in $Comparison) {
    Write-Host $item.InputObject  $item.SideIndicator
}

$off = $false

$Baseline = @{}




# while ($off -eq $false) {
#     Get-ScheduledTask


#     Start-Sleep -Seconds 60
# }