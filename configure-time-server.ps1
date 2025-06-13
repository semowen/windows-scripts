net stop w32time
w32tm /config /syncfromflags:manual /manualpeerlist:”time.server.com, time2.server.com”
w32tm /config /reliable:yes
net start w32time

w32tm /query /configuration
w32tm /query /status
