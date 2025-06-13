Netsh trace start scenario=NetConnection IPv4.Address=171.162.110.200 capture=yes report=yes persistent=no maxsize=1024 correlation=yes traceFile=C:\Logs\boa2.etl

netsh trace start capture=yes Ethernet.Type=IPv4 IPv4.Address=171.162.110.200 traceFile=C:\Logs\NetTrace.etl

netsh trace stop




netsh trace start capture=yes IPv4.Address=192.168.122.2





netsh trace start capture=yes Ethernet.Type=IPv4 IPv4.Address=171.162.110.200

netsh trace start capture = yes ipv4.address == 172.162.110.200 traceFile=C:\Logs\boa3.etl
