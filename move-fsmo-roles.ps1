Move-ADDirectoryServerOperationMasterRole -Identity "aperio-dc1" -OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster





function Get-ADFSMORole {
     [CmdletBinding()]
     param
     ()

     $roles = @()
     $roles += Get-ADDomain | Select-Object InfrastructureMaster,PDCEmulator,RIDMaster
     $roles += Get-ADForest | Select-Object DomainNamingMaster,SchemaMaster
     $roles | Format-List
 }
