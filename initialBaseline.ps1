$ComputerName = $env:COMPUTERNAME
$switch = $True

$rootBase = @{}


foreach ($computer in $ComputerName) {
    $TaskList = [System.Collections.ArrayList]@()
    $ScheduledTasks = Get-ScheduledTask | Select-Object TaskName
    foreach($scheduledTask in $ScheduledTasks) {
        $currentLine = @("Scheduled Task", $scheduledTask.TaskName)
        [void]$TaskList.Add($currentLine)
    }
    $rootBase.Add($computer, $TaskList)
}