### BATCH RENAME PCs
# Open modal to ask for admin credentials. Set these as a variable.
$admincredentials = Get-Credential
# Set variable - import data from CSV
# Change this path as needed.
$list = Import-Csv c:\scripts\hostlist.csv
# For each item in the CSV, run Group Policy Update immediately
Foreach ( $pc in $list ) {
  Invoke-GPUpdate –Computer $pc –RandomDelayInMinutes 0 -Target "User" -Force
}
