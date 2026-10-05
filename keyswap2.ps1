param (
    [Parameter(Mandatory = $true)][string]$filePath,
    [Parameter(Mandatory = $true)][string]$fileList
)
# Start timer
$sw = [System.Diagnostics.Stopwatch]::StartNew()

$keyPath = "$env:USERPROFILE\.tools\keyswap"
Write-Verbose ":: Tool location `$keyPath set to $keyPath"

$backupPath = Join-Path $filePath .xmpbk
Write-Verbose ":: Backup path `$backupPath set to: $backupPath"

Write-Verbose ":: filePath: $filePath"
# Write-Verbose ":: Contents of fileList ($fileList):`n"
# Get-Content $fileList

# Read and clean file list, filter for .xmp files only
$files = Get-Content $fileList |
    ForEach-Object { $_.Trim('"') } |
    Where-Object { $_.ToLower().EndsWith(".xmp") }

    Write-Verbose ":: File List is:`n$files"

# Run msxsl in parallel
$files | ForEach-Object -Parallel {
    $curFileAbs = Join-Path $using:filePath $_

    Write-Host ":: Processing $curFileAbs"

    Write-Verbose ":: Copy-Item -Path $curFileAbs -Destination (Join-Path $using:backupPath $_) -Force"
    Copy-Item -Path $curFileAbs -Destination (Join-Path $using:backupPath $_) -Force

    Write-Verbose ":: & `"$using:keyPath\msxsl`" `"$curFileAbs`" `"keyswap.xslt`" -o `"$curFileAbs`""
    & "$using:keyPath\msxsl" "$curFileAbs" "keyswap.xslt" -o "$curFileAbs"

} -ThrottleLimit 12  # Optional limit

$sw.Stop()
Write-Host "`nExecution time: $($sw.ElapsedMilliseconds) ms"

Write-Host "`nProcessing complete. Press any key to exit..."
[void][System.Console]::ReadKey($true)
