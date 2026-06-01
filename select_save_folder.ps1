Add-Type -AssemblyName System.Windows.Forms

$dialog = New-Object System.Windows.Forms.SaveFileDialog
$dialog.Title = "Choisir l'emplacement d'enregistrement"
$dialog.Filter = "Tous les fichiers (*.*)|*.*"
$dialog.FileName = "Inutile de renommer la vidéo ici, ce nom sera remplacé"
$dialog.OverwritePrompt = $false

if ($dialog.ShowDialog() -eq "OK") {
    Split-Path $dialog.FileName
}