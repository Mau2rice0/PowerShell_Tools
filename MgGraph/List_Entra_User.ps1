
Install-Module Microsoft.Graph -Scope CurrentUser

# Authentifizieren Sie sich bei Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All"


# Pfad zur CSV-Datei auf dem Desktop des aktuellen Benutzers
$desktopPath = [Environment]::GetFolderPath("Desktop")
$csvFilePath = Join-Path -Path $desktopPath -ChildPath "exported_users.csv"

# Überprüfen, ob die CSV-Datei bereits existiert
if (-Not (Test-Path -Path $csvFilePath)) {
    # CSV-Datei existiert nicht, also Benutzerdaten exportieren
    $users = Get-MgUser -All
    $users | Select-Object Id, DisplayName, UserPrincipalName, Mail | Export-Csv -Path $csvFilePath -NoTypeInformation
    Write-Host "Benutzer wurden erfolgreich nach $csvFilePath exportiert."
} else {
    # CSV-Datei existiert bereits, hier können Sie definieren, wie die Datei genutzt werden soll
    Write-Host "Die CSV-Datei existiert bereits unter $csvFilePath."
}

# Alle Benutzer auslesen
$users = Get-MgUser -All

$exportPath = $csvFilePath
$users | Select-Object Id, DisplayName, UserPrincipalName, Mail | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "Benutzer wurden erfolgreich nach $exportPath exportiert."

# Trennen Sie die Verbindung zu Microsoft Graph
Disconnect-MgGraph
