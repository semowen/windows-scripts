$vmName = "vmname"
$vmDataStore = "datastore"  
$vmDatastore2 = "datastore"




Function Set-Drives ($VM, $HC, $GC, $drivesizes, $driveletters){
	$x=1
	foreach ( $driveletter in $driveletters) {
	$diskpart = "echo select disk $x > c:\diskpart.txt && echo attributes disk clear readonly >> c:\diskpart.txt && echo online disk >> c:\diskpart.txt && echo select disk $x >> c:\diskpart.txt && echo convert gpt >> c:\diskpart.txt && echo create partition primary >> c:\diskpart.txt && echo format quick fs=ntfs >> c:\diskpart.txt && echo assign letter=$driveletter >> c:\diskpart.txt && diskpart.exe /s c:\diskpart.txt"
		
		Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $diskpart
		$x++
		}
}
 
 
 
 
 $VM = $vmName


$drivenumber = (Read-Host "How many data drives?")
$drivesizes = @()
$driveletters = @()

for ($i=1; $i -le $drivenumber; $i++) {
$drivesize = (Read-Host "Enter Drive size of drive #"$i )
$driveletter = (Read-Host "Enter Drive Letter of drive #"$i )
$drivesizes += $drivesize
$driveletters += $driveletter
write-output $drivesizes
write-output $driveletters
}


$ESXHost = get-vmhost -VM $vmName
$HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter ESX host credentials for $ESXHost", "root", "")
$GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Guest credentials for $VM", "administrator", "")


Set-Drives $VM $HostCred $GuestCred $drivesizes $driveletters

