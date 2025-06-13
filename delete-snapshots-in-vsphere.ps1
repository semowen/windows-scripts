# Specify the partial name of the snapshots to be deleted
$partialSnapshotName = "vm-"

foreach ($vm in $vmList) {
    # Get snapshots for the current virtual machine
    $snapshots = Get-Snapshot -VM $vm

    # Loop through each snapshot
    foreach ($snapshot in $snapshots) {
        # Check if the snapshot name contains the specified partial name
        if ($snapshot.Name -like "*$partialSnapshotName*") {
            # Delete the snapshot
            # Remove-Snapshot -Snapshot $snapshot -Confirm:$false
            Write-Host "Snapshot $($snapshot.Name) deleted for $($vm.Name)"
        
		}
    }
}



--------------------------------------------------



Connect-VIServer -Server vcenter



# Specify the partial description to search for in snapshot descriptions
$partialSnapshotDescription = "Lifecycle"

# Get all snapshots with descriptions containing the specified partial description
$snapshots = Get-VM | Get-Snapshot | Where-Object { $_.Description -like "*$partialSnapshotDescription*" }

# Loop through each snapshot and delete it
foreach ($snapshot in $snapshots) {
    Remove-Snapshot -Snapshot $snapshot -Confirm:$false
    Write-Host "Snapshot $($snapshot.Description) deleted for $($snapshot.VM.Name)"
}
