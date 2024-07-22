#Requires -RunAsAdministrator 
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Hauptfenster erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Hyper-V VM Creator'
$form.Size = New-Object System.Drawing.Size(300,300)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog' # Fenstergröße fixieren
$form.MaximizeBox = $false # Maximieren-Button deaktivieren
$form.MinimizeBox = $false # Minimieren-Button deaktivieren

# Funktion zum Erstellen der VM
function Create-VM {
    param($vmName, $ramGB, $cpuCount, $diskSizeGB, $networkAdapterName)
    $ramBytes = [int]$ramGB * 1GB
    $diskSizeBytes = [int]$diskSizeGB * 1GB

    New-VM -Name $vmName -MemoryStartupBytes $ramBytes -Generation 2
    Set-VMProcessor -VMName $vmName -Count $cpuCount
    New-VHD -Path "V:\VM-Storage\$vmName\$vmName.vhdx" -SizeBytes $diskSizeBytes
    Add-VMHardDiskDrive -VMName $vmName -Path "V:\VM-Storage\$vmName\$vmName.vhdx"
    Add-VMNetworkAdapter -VMName $vmName -Name $networkAdapterName
    Start-VM -Name $vmName
    [System.Windows.Forms.MessageBox]::Show("VM $vmName wurde erfolgreich erstellt und gestartet.")
    $vmName = ""
    $ramGB = ""
    $cpuCount = ""
    $diskSizeGB = ""
    $networkAdapterName = ""

}


# GUI-Elemente hinzufügen
$labels = 'VM-Name', 'RAM in GB', 'CPU-Anzahl', 'Festplattenkapazitaet in GB', 'Netzwerkadapter-Name'
$textBoxes = @()
$y = 20
foreach ($label in $labels) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $label
    $lbl.Location = New-Object System.Drawing.Point(10, $y)
    $lbl.Size = New-Object System.Drawing.Size(120, 30)
    $form.Controls.Add($lbl)

    $txtBox = New-Object System.Windows.Forms.TextBox
    $txtBox.Location = New-Object System.Drawing.Point(130, $y)
    $txtBox.Size = New-Object System.Drawing.Size(150, 30)
    $form.Controls.Add($txtBox)
    $textBoxes += $txtBox

    $y += 30
}

$y += 35 # Anpassung für den Button

$createVmButton = New-Object System.Windows.Forms.Button
$createVmButton.Location = New-Object System.Drawing.Point(10, $y)
$createVmButton.Size = New-Object System.Drawing.Size(265, 50)
$createVmButton.Text = 'VM erstellen'
$form.Controls.Add($createVmButton)

$createVmButton.Add_Click({
    try {
        Create-VM -vmName $textBoxes[0].Text -ramGB $textBoxes[1].Text -cpuCount $textBoxes[2].Text -diskSizeGB $textBoxes[3].Text -networkAdapterName $textBoxes[4].Text
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Fehler beim Erstellen der VM: $_")
    }
})

# Fenster anzeigen
$form.ShowDialog()
