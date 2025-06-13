#connect-viserver vcenter

$vmName = ( Read-Host "Enter VM name" )


$IP = "10.145.11.52"			#IP
$SNM = "255.255.255.0"		#subnet
$GW = "10.145.11.3"		#gateway
$DNS = "10.145.40.52"		#DNS 1
$DNS2 = "10.145.40.51"		#DNS 2




$ESXHost = get-vmhost -VM $vmName
$HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter ESX host credentials for $ESXHost", "root", "")
$GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Guest credentials for $VM", "administrator", "")

$VM = $vmName



### set computer IP address
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

 
Set-WinVMIP $VM $HostCred $GuestCred $IP $SNM $GW $DNS $DNS2
