#########################################################################
#  Template for deploying a machine in VMware vSphere environment v6.0  #
#  Update below variables to start					#
#########################################################################

#Connect to vSphere Server
connect-viserver vcenter

#
$vmName = "vmname"				#virtual machine name
$vmDataStore = "data01"	#Data store for Operating System
$vmDatastore2 = "data01"	#Data store for Data drives
$network = "virtual-switch"				#network of virtual distributed switch
$myTemplate = get-template -name "Windows 2016 DC PV Template 11-15-2017"	#virtual machine template name

$IP = "172.28.6.169"			#IP
$SNM = "255.255.255.0"		#subnet
$GW = "172.28.6.243"		#gateway
$DNS = "10.31.13.17"		#DNS 1
$DNS2 = "10.96.1.74"		#DNS 2

#resource pools: SD-Prod, SD-Lab
$rpool = "PROD"

#OS Customizations
$custom = "Windows 2016 CLI"
#########################################################################


#Creating the new Virtual Machine
new-vm -name $vmName -template $myTemplate -ResourcePool $rpool -Datastore $vmDataStore -OSCustomizationSpec $custom
get-vm $vmName | get-networkadapter | Set-NetworkAdapter -networkname $network 

#######Start VM and customization process ##########

start-vm $vmName

#Needs to wait for 
#Start-Sleep -Seconds 105;
$x = 300
$length = $x / 100
while($x -gt 0) {
  $min = [int](([string]($x/60)).split('.')[0])
  $text = " " + $min + " minutes " + ($x % 60) + " seconds left"
  Write-Progress "Pausing Script" -status $text -perc ($x/$length)
  start-sleep -s 1
  $x--
}

restart-vmguest $vmName


### set up IP in windows
Function Set-WinVMIP ($VM, $HC, $GC, $IP, $SNM, $GW, $DNS, $DNS2){
 $netsh = "c:\windows\system32\netsh.exe interface ip set address Ethernet1 static $IP $SNM $GW 1"
 $netsh2 = "c:\windows\system32\netsh.exe interface ip add dnsservers Ethernet1 $DNS"
 $netsh3 = "c:\windows\system32\netsh.exe interface ip add dnsservers Ethernet1 $DNS2 index=2"
 
 Write-Host "Setting IP address and DNS for $VM..."
 Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $netsh
 Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $netsh2
 Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $netsh3
 Write-Host "Setting IP address completed."
 Write-Host "Setting domain"
 
}


### add computer to domain
Function Set-Domain ($VM, $HC, $GC, $domain, $domainuser, $pass){
	$netdom = "netdom join /Domain:$domain $vm /UserD:$domainuser /PasswordD:$pass"
	Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat $netdom
 }

### set up drives in Windows environment

Function Set-Drives ($VM, $HC, $GC, $drivesizes, $driveletters){
	$x=1
	foreach ( $driveletter in $driveletters) {
	$diskpart = "echo select disk $x > c:\diskpart.txt && echo attributes disk clear readonly >> c:\diskpart.txt && echo online disk >> c:\diskpart.txt && echo select disk $x >> c:\diskpart.txt && echo convert gpt >> c:\diskpart.txt && echo create partition primary >> c:\diskpart.txt && echo format quick fs=ntfs >> c:\diskpart.txt && echo assign letter=$driveletter >> c:\diskpart.txt && diskpart.exe /s c:\diskpart.txt"
		
		Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $diskpart
		$x++
		}
}
 


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

foreach ($drive in $drivesizes){
	$vm = get-vmguest $vmName
	$vm[0].VM | new-harddisk -capacityGB $drive -datastore $vmDataStore2 -storageformat Thin
	}
	

$ESXHost = get-vmhost -VM $vmName
$HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter ESX host credentials for $ESXHost", "root", "")
$GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Guest credentials for $VM", "administrator", "")

$domain = ( Read-Host "Enter domain for adding to domain" )
$domainuser = (Read-Host "Enter domain username")
$pass = (Get-Credential $domainuser -Message "Please Enter your Domain account password.").GetNetworkCredential().Password

$VM = $vmName
Set-WinVMIP $VM $HostCred $GuestCred $IP $SNM $GW $DNS $DNS2
Set-Drives $VM $HostCred $GuestCred $drivesizes $driveletters
Set-Domain $VM $HostCred $GuestCred $domain $domainuser $pass



$x = 45
$length = $x / 100
while($x -gt 0) {
  $min = [int](([string]($x/60)).split('.')[0])
  $text = " " + $min + " minutes " + ($x % 60) + " seconds left"
  Write-Progress "Pausing Script" -status $text -perc ($x/$length)
  start-sleep -s 1
  $x--
}

restart-vmguest $vm

