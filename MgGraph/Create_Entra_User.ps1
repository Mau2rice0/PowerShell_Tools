Install-Module Microsoft.Graph -Scope CurrentUser

Connect-MgGraph -Scopes "User.ReadWrite.All"

$userProperties = @{
    accountEnabled = $true
    displayName = "Neuer Benutzer"
    mailNickname = "neuerbenutzer"
    userPrincipalName = "neuerbenutzer@IhreDomain.com"
    passwordProfile = @{
        forceChangePasswordNextSignIn = $true
        password = "EinSehrSicheresPasswort123!"
    }
}

$newUser = New-MgUser -BodyParameter $userProperties


if ($newUser) {
    Write-Host "Benutzer $($newUser.displayName) wurde erfolgreich erstellt."
} else {
    Write-Host "Fehler beim Erstellen des Benutzers."
}


Disconnect-MgGraph
