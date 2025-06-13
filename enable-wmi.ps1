




To enable WMI traffic using separate rules for DCOM, WMI, callback sink and outgoing connections

To establish a firewall exception for DCOM port 135, use the following command.

netsh advfirewall firewall add rule dir=in name="DCOM" program=%systemroot%\system32\svchost.exe service=rpcss action=allow protocol=TCP localport=135

To establish a firewall exception for the WMI service, use the following command.

netsh advfirewall firewall add rule dir=in name ="WMI" program=%systemroot%\system32\svchost.exe service=winmgmt action = allow protocol=TCP localport=any

To establish a firewall exception for the sink that receives callbacks from a remote computer, use the following command.

netsh advfirewall firewall add rule dir=in name ="UnsecApp" program=%systemroot%\system32\wbem\unsecapp.exe action=allow

To establish a firewall exception for outgoing connections to a remote computer that the local computer is communicating with asynchronously, use the following command.




netsh advfirewall firewall add rule dir=in name="DCOM" program=%systemroot%\system32\svchost.exe service=rpcss action=allow protocol=TCP localport=135

netsh advfirewall firewall add rule dir=in name ="WMI" program=%systemroot%\system32\svchost.exe service=winmgmt action = allow protocol=TCP localport=any

netsh advfirewall firewall add rule dir=in name ="UnsecApp" program=%systemroot%\system32\wbem\unsecapp.exe action=allow

netsh advfirewall firewall add rule dir=out name ="WMI_OUT" program=%systemroot%\system32\svchost.exe service=winmgmt action=allow protocol=TCP localport=any
