# Folder-AD-Groups
Powershell script to create AD security groups for Folders.

Input the location of your folders plus some other info and the script will go through and create AD groups for each of them. It creates two groups for each: a modify group and a read-only group.

The script will then assign the proper rights the the folders so that the modify group has modify rights and the read-only group has read-only rights.


