$ComputerName = $env:COMPUTERNAME
$switch = $True

$rootBase = @{}

## Initial Baseline
foreach ($computer in $ComputerName) {
    $TaskList = [System.Collections.ArrayList]@()
    $ScheduledTasks = Get-ScheduledTask | Select-Object TaskName
    foreach($scheduledTask in $ScheduledTasks) {
        $currentLine = @("Scheduled Task", $scheduledTask.TaskName)
        [void]$TaskList.Add($currentLine)
    }
    $rootBase.Add($computer, $TaskList)
}

while ($switch -eq $True) {
    foreach ($computer in $ComputerName) {
        $NewTaskList = [System.Collections.ArrayList]@()
        
        $ScheduledTasks = Get-ScheduledTask | Select-Object TaskName
        foreach($scheduledTask in $ScheduledTasks) {
            $currentLine = @("Scheduled Task", $scheduledTask.TaskName)
            [void]$NewTaskList.Add($currentLine)
        }

        

        $Comparison = Compare-Object -DifferenceObject $NewTaskList -ReferenceObject $rootBase[$env:COMPUTERNAME]
        $rootBase[$computer] = $NewTaskList
        foreach ($item in $Comparison) {
            Write-Host $item.InputObject $item.SideIndicator
        }
    }
}