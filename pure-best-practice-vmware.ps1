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
  
