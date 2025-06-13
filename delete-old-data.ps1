# Define the path to the directory you want to clean up
$directoryPath = "G:\data\Production\Image_Quality"

# Define the number of days to retain for creation and modification
$daysToKeep = 365

# Define whether the script is in dry-run mode
$dryRun = $false  # Set to $false to actually delete files/folders

# Get the current date
$currentDate = Get-Date

# Calculate the cutoff date for both creation and modification
$cutoffCreationDate = $currentDate.AddDays(-$daysToKeep)
$cutoffModifiedDate = $currentDate.AddDays(-$daysToKeep)

# Define the log file path with rotation support
$logFolderPath = "G:\data\Production\Image_Quality\Logs"
if (!(Test-Path -Path $logFolderPath)) {
    New-Item -Path $logFolderPath -ItemType Directory -Force
}

# Define the current log file for this month
$logFilePath = Join-Path -Path $logFolderPath -ChildPath ("deletion_log_$($currentDate.ToString('yyyy-MM')).txt")

# Archive old logs at the start of a new month
$oldLogs = Get-ChildItem -Path $logFolderPath -Filter "deletion_log_*.txt"
foreach ($log in $oldLogs) {
    if ($log.Name -ne [IO.Path]::GetFileName($logFilePath)) {
        # Archive or move old log files
        Move-Item -Path $log.FullName -Destination "$($logFolderPath)\Archive\" -Force
    }
}

# Create the archive folder if it doesn't exist
if (!(Test-Path -Path "$logFolderPath\Archive")) {
    New-Item -Path "$logFolderPath\Archive" -ItemType Directory -Force
}

# Get a list of files and folders older than the cutoff date for creation or modification
$oldItems = Get-ChildItem -Path $directoryPath -Recurse | Where-Object { 
    ($_.CreationTime -lt $cutoffCreationDate) -and ($_.LastWriteTime -lt $cutoffModifiedDate)
}

# Define the list of exempted folders
$exemptedFolders = @("G:\data\Production\Image_Quality\Golden", "G:\data\Production\Image_Quality\Golden_Reference_Images")

# Delete files and folders and log the deletions along with the last modified and created dates
foreach ($item in $oldItems) {
    # Skip items inside exempted folders
    if ($exemptedFolders -contains $item.DirectoryName -or $exemptedFolders -contains $item.FullName) {
        Add-Content -Path $logFilePath -Value ("Skipped exempted item: $($item.FullName) - Created: $($item.CreationTime) - Last Modified: $($item.LastWriteTime) - $(Get-Date)")
        continue
    }

    if ($item.PSIsContainer) {
        # Check if the folder is empty
        if ((Get-ChildItem -Path $item.FullName -Recurse).Count -eq 0) {
            # Log the folder deletion
            Add-Content -Path $logFilePath -Value ("Deleted folder: $($item.FullName) - Created: $($item.CreationTime) - Last Modified: $($item.LastWriteTime) - $(Get-Date)")
            
            # Delete or simulate deletion
            if (-not $dryRun) {
                Remove-Item -Path $item.FullName -Recurse -Force
            } else {
                Add-Content -Path $logFilePath -Value ("Dry run: Folder $($item.FullName) would be deleted.")
            }
        } else {
            # Log that the folder was skipped because it's not empty
            Add-Content -Path $logFilePath -Value ("Skipped folder (not empty): $($item.FullName) - Created: $($item.CreationTime) - Last Modified: $($item.LastWriteTime) - $(Get-Date)")
        }
    } else {
        # Check if the file ends with .svs
        if ($item.Extension -eq ".svs") {
            # Log the file deletion
            Add-Content -Path $logFilePath -Value ("Deleted file: $($item.FullName) - Created: $($item.CreationTime) - Last Modified: $($item.LastWriteTime) - $(Get-Date)")
            
            # Delete or simulate deletion
            if (-not $dryRun) {
                Remove-Item -Path $item.FullName -Force
            } else {
                Add-Content -Path $logFilePath -Value ("Dry run: File $($item.FullName) would be deleted.")
            }
        } else {
            # Log that the file was skipped due to the extension not being .svs
            Add-Content -Path $logFilePath -Value ("Skipped file (not .svs): $($item.FullName) - Created: $($item.CreationTime) - Last Modified: $($item.LastWriteTime) - $(Get-Date)")
        }
    }
}

# Log the script execution time for troubleshooting
Add-Content -Path $logFilePath -Value ("Script executed at: $(Get-Date)")
