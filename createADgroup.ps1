get-childitem \\avo\temp\Greg | ?{ $_.PSIsContainer } | Select-Object name | Export-Csv \\avo\temp\greg\departments.csv

$groupnames = Import-Csv \\avo\temp\greg\departments.csv

foreach ($group in $groupnames) {
$name = $group.Name 
New-ADGroup -name "$name -Modify" -path "OU=File Server,OU=Groups,dc=fnba,dc=com" -GroupScope Global -GroupCategory Security 
}
foreach ($group in $groupnames) {
$name = $group.Name 
New-ADGroup -Name "$name -Read Only" -Path "OU=File Server,OU=Groups,dc=fnba,dc=com" -GroupScope Global -GroupCategory Security 
}

Set-Location -Path \\avo\temp\Greg

$homeFolders = Get-ChildItem \\avo\temp\Greg -Directory
foreach ($homeFolder in $homeFolders) {

$colrightsmod = [System.Security.AccessControl.FileSystemRights]"Modify"

$inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None

$objtype =[System.Security.AccessControl.AccessControlType]::Allow

$secgroup = New-Object System.Security.Principal.NTAccount("fnba.com\$homeFolder -Modify")
                                                                                 
$objACEmod = New-Object System.Security.AccessControl.FileSystemAccessRule  ($secgroup, $colrightsmod, $inheritanceFlag, $PropagationFlag, $objtype)
$objacl = Get-Acl "\\avo\temp\Greg\$homefolder"
$objacl.AddAccessRule($objACEmod)

(get-item $homeFolder).SetAccessControl($objacl)  
}

foreach ($homeFolder in $homeFolders) {

$colrightsread = [System.Security.AccessControl.FileSystemRights]"read"

$secgroup = New-Object System.Security.Principal.NTAccount("FNBA.com\$homeFolder -Read Only")
                                                                                 
$objACEread = New-Object System.Security.AccessControl.FileSystemAccessRule  ($secgroup, $colrightsread, $inheritanceFlag, $PropagationFlag, $objtype)
$objacl = Get-Acl "\\avo\temp\Greg\$homefolder"  
$objacl.AddAccessRule($objACEread)

(get-item $homeFolder).SetAccessControl($objacl)
} 