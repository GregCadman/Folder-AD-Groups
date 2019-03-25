$location = Read-Host -Prompt 'Enter Location of Folders'
$domain = Read-Host -Prompt 'Enter domain name'
$OU = Read-Host -Prompt 'Enter OU path (ex. OU=File Server,OU=Groups,dc=test,dc=com)'

get-childitem $location | ?{ $_.PSIsContainer } | Select-Object name | Export-Csv $location\departments.csv

$groupnames = Import-Csv $location\departments.csv

foreach ($group in $groupnames) {
$name = $group.Name 
New-ADGroup -name "$name -Modify" -path "$OU" -GroupScope Global -GroupCategory Security 
}
foreach ($group in $groupnames) {
$name = $group.Name 
New-ADGroup -Name "$name -Read Only" -Path "$OU" -GroupScope Global -GroupCategory Security 
}

Start-Sleep -Seconds 5

Set-Location -Path $location

$homeFolders = Get-ChildItem $location -Directory
foreach ($homeFolder in $homeFolders) {

$colrightsmod = [System.Security.AccessControl.FileSystemRights]"Modify"

$inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None

$objtype =[System.Security.AccessControl.AccessControlType]::Allow

$secgroup = New-Object System.Security.Principal.NTAccount("$domain\$homeFolder -Modify")
                                                                                 
$objACEmod = New-Object System.Security.AccessControl.FileSystemAccessRule  ($secgroup, $colrightsmod, $inheritanceFlag, $PropagationFlag, $objtype)
$objacl = Get-Acl "$location\$homefolder"
$objacl.AddAccessRule($objACEmod)

(get-item $homeFolder).SetAccessControl($objacl)  
}

foreach ($homeFolder in $homeFolders) {

$colrightsread = [System.Security.AccessControl.FileSystemRights]"read"

$secgroup = New-Object System.Security.Principal.NTAccount("$domain\$homeFolder -Read Only")
                                                                                 
$objACEread = New-Object System.Security.AccessControl.FileSystemAccessRule  ($secgroup, $colrightsread, $inheritanceFlag, $PropagationFlag, $objtype)
$objacl = Get-Acl "$location\$homefolder"  
$objacl.AddAccessRule($objACEread)

(get-item $homeFolder).SetAccessControl($objacl)
} 