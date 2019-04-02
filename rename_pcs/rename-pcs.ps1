### BATCH RENAME PCs
# Open modal to ask for admin credentials. Set these as a variable.
$admincredentials = Get-Credential
# Set variable - import data from CSV
$list = Import-Csv c:\scripts\list.csv -Header OldName,NewName
# For each item in OldName column in the CSV, rename using the NewName column.
Foreach ( $pc in $list ) {Rename-Computer -ComputerName $pc.OldName -NewName $pc.NewName -DomainCredential $admincredentials -Force -Restart}
