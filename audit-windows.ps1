echo hostname
hostname

echo net start 
net start 

echo net user admin
net user admin
echo net user guest
net user guest

echo winreg
Get-Acl -Path HKLM:\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg\ | Format-List

echo net accounts
net accounts

echo net localgroup administrators
net localgroup administrators

echo Audit Policy Local Policy
auditpol.exe /get /category:*

