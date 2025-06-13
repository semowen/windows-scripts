#$creds = Get-Credential
#Connect-VIServer -Server vcenter -Credential $creds
$hosts = get-cluster "prod" | get-vmhost
foreach ($esx in $hosts) 
 {
 $esxcli=get-esxcli -VMHost $esx -v2
        $satpArgs = $esxcli.storage.nmp.satp.rule.remove.createArgs()
        $satpArgs.description = "Pure Storage FlashArray SATP Rule"
        $satpArgs.model = "FlashArray"
        $satpArgs.vendor = "PURE"
        $satpArgs.satp = "VMW_SATP_ALUA"
        $satpArgs.psp = "VMW_PSP_RR"
        $satpArgs.pspoption = "iops=1"
        $esxcli.storage.nmp.satp.rule.add.invoke($satpArgs)
 }   
  


foreach ($esx in $hosts)
{
        $esxcli=get-esxcli -VMHost $esx -v2
        $satpArgs = $esxcli.storage.nmp.satp.rule.remove.createArgs()
        $satpArgs.description = "Pure Storage FlashArray SATP Rule"
        $satpArgs.model = "FlashArray"
        $satpArgs.vendor = "PURE"
        $satpArgs.satp = "VMW_SATP_ALUA"
        $satpArgs.psp = "VMW_PSP_RR"
        $satpArgs.pspoption = "iops=1"
        $esxcli.storage.nmp.satp.rule.add.invoke($satpArgs)
}

$deviceargs = $esxcli.storage.nmp.psp.roundrobin.deviceconfig.get.createargs()
            $deviceargs.device = $device.CanonicalName
            $deviceconfig = $esxcli.storage.nmp.psp.roundrobin.deviceconfig.get.invoke($deviceargs)
            $nmpargs =  $esxcli.storage.nmp.psp.roundrobin.deviceconfig.set.createargs()
            $nmpargs.iops = $iopsvalue
            $nmpargs.type = "iops"


