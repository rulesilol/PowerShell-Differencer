$ComputerName = $env:COMPUTERNAME
$switch = $True

$rootBase = @{}

## Initial Baseline
foreach ($computer in $ComputerName) {
    $List = [System.Collections.ArrayList]@()
    
    $ScheduledTasks = Get-ScheduledTask | Select-Object TaskName
    foreach($scheduledTask in $ScheduledTasks) {
        $currentLine = @("Scheduled Task", $scheduledTask.TaskName)
        [void]$List.Add($currentLine)
    }

    $Services = Get-Service | Select-Object -Property Name
    foreach($service in $Services) {
        $currentLine = @("Service", $service.Name)
        [void]$List.Add($currentLine)
    }

    $rootBase.Add($computer, $List)
}

Write-Host "Initial Baseline Complete"


while ($switch -eq $True) {
    foreach ($computer in $ComputerName) {
        $NewList = [System.Collections.ArrayList]@()
        
        $ScheduledTasks = Get-ScheduledTask | Select-Object TaskName
        foreach($scheduledTask in $ScheduledTasks) {
            $currentLine = @("Scheduled Task", $scheduledTask.TaskName)
            [void]$NewList.Add($currentLine)
        }

        $Services = Get-Service | Select-Object -Property Name
        foreach($service in $Services) {
            $currentLine = @("Service", $service.Name)
            [void]$NewList.Add($currentLine)
        }



        $Comparison = Compare-Object -DifferenceObject $NewList -ReferenceObject $rootBase[$computer]
        $rootBase[$computer] = $NewList
        foreach ($item in $Comparison) {
            # Write-Host $item.InputObject $item.SideIndicator
            $Type = $item.InputObject[0]
            if ($item.SideIndicator -eq "=>") {
                Write-Host $computer $item.InputObject[0] $item.InputObject[1] "$Type was added in $computer"
            } elseif ($item.SideIndicator -eq "<=") {
                Write-Host $computer $item.InputObject[0] $item.InputObject[1] "$Type was removed $computer"
            }
        }
    }
}