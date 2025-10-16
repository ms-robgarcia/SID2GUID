# SID2GUID
A simple PowerShell script to convert SIDs found in Entra ID Joined Windows devices to GUIDs from directory objects in Entra ID. The script can also convert GUIDs back to SIDs.

## Instructions
1. Open the script *.ps1 file in PowerShell
2. Provide a SID with the prefix "S-1-12-1-" (i.e., an Entra ID object SID) or an Entra ID object GUID
3. The script will parse through the value, determine if it's a valid SID or GUID, and will convert it to either SID or GUID depending on what the original value is

