param (
    [Parameter(Mandatory = $true)][string]$FileBase,
    [Parameter(Mandatory = $true)][string]$FileName
)


$keyPath = "$env:USERPROFILE\.tools\keyswap"
Write-Verbose ":: Tool location `$keyPath set to $keyPath"

$backupPath = "$FileBase.xmpbk"
Write-Verbose ":: Backup path `$backupPath set to: $backupPath"

$curFileAbs = Join-Path $FileBase $FileName
Write-Verbose ":: Processing file --> $curFileAbs"

<#
Write-Verbose ":: Attempting : New-Item -ItemType Directory -Path `"$backupPath`""

if (-not (Test-Path -Path "$backupPath\*")) {
    try {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    } catch {
        Write-Host ":: *** ERROR: Could not create backup directory. Aborting."
        Read-Host "Press Enter to exit..."
        exit
    }
}
#>

Write-Verbose ":: Copy-Item -Path $curFileAbs -Destination (Join-Path $backupPath $FileName) -Force"
Copy-Item -Path $curFileAbs -Destination (Join-Path $backupPath $FileName) -Force

Write-Verbose ":: & `"$keyPath\msxsl`" $curFileAbs `"keyswap.xslt`" -o $curFileAbs"
& "$keyPath\msxsl" $curFileAbs "keyswap.xslt" -o $curFileAbs
