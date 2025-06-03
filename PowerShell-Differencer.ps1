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

    $ListeningPorts = Get-NetTCPConnection -State Listen | Select-Object LocalPort, OwningProcess
    foreach($ListeningPort in $ListeningPorts) {
        $currentLine = @("Listening Port", $ListeningPort.LocalPort)
        [void]$List.Add($currentLine)
    }

    $LocalUsers = 

    $rootBase.Add($computer, $List)
}

Write-Host "Initial Baseline Complete"
Write-Host "Time, Computer, Type, Information, Comment"


while ($switch -eq $True) {
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

        $ListeningPorts = Get-NetTCPConnection -State Listen | Select-Object LocalPort, OwningProcess
        foreach($ListeningPort in $ListeningPorts) {
            $currentLine = @("Listening Port", $ListeningPort.LocalPort)
            [void]$List.Add($currentLine)
    }



        $Comparison = Compare-Object -DifferenceObject $List -ReferenceObject $rootBase[$computer]
        $rootBase[$computer] = $List
        
        foreach ($item in $Comparison) {
            # Write-Host $item.InputObject $item.SideIndicator
            $Type = $item.InputObject[0]
            $CurrentDateTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss.fff"
            if ($item.SideIndicator -eq "=>") {
                Write-Host $CurrentDateTime $computer $item.InputObject[0] $item.InputObject[1] "A $Type was added on $computer" -Separator ", "
            } elseif ($item.SideIndicator -eq "<=") {
                Write-Host $CurrentDateTime $computer $item.InputObject[0] $item.InputObject[1] "A $Type was removed on $computer" -Separator ", "
            }
        }
    }
}