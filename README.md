# Folder-AD-Groups
Powershell script to create AD groups for Folders

Script scans a directory and creates two AD groups for every folder there. One group is for 'modify' rights, one group for 'read only' rights

The script then alters the ACLs of the folders to align with the newly created AD groups.


