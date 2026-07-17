$zipPath = "C:\Users\kande\AppData\Local\Android\Sdk\.temp\ndk-r27c-http.zip"
$ndkDir = "C:\Users\kande\AppData\Local\Android\Sdk\ndk\27.1.12297006"

Write-Output "=== Verifying downloaded ZIP ==="
$file = [System.IO.File]::OpenRead($zipPath)
$file.Seek(-22, [System.IO.SeekOrigin]::End) | Out-Null
$reader = New-Object System.IO.BinaryReader($file)
$bytes = $reader.ReadBytes(22)
$reader.Close()
$file.Close()
$eocd = -join ($bytes | ForEach-Object { $_.ToString("X2") })
if ($eocd.Substring(0,8) -eq "504B0506") {
    Write-Output "ZIP file is COMPLETE and valid!"
} else {
    Write-Output "ZIP file is INCOMPLETE!"
    exit 1
}

Write-Output "=== Extracting NDK to: $ndkDir ==="
Write-Output "This may take several minutes..."

# Ensure target directory exists
if (-not (Test-Path $ndkDir)) {
    New-Item -ItemType Directory -Path $ndkDir -Force | Out-Null
}

# Extract using Expand-Archive
Expand-Archive -Path $zipPath -DestinationPath $ndkDir -Force

Write-Output "=== Extraction complete ==="

# Check what was extracted
Get-ChildItem "$ndkDir" -Depth 1 -ErrorAction SilentlyContinue | Select-Object Name, Mode | Format-Table -AutoSize

Write-Output ""
Write-Output "=== NDK installation verified ==="
if (Test-Path "$ndkDir\ndk-build.cmd" -or (Get-ChildItem "$ndkDir\ndk-build*" -ErrorAction SilentlyContinue)) {
    Write-Output "NDK is ready to use!"
} else {
    Write-Output "Checking subdirectories..."
    Get-ChildItem "$ndkDir" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        if (Test-Path "$_.FullName\ndk-build.cmd" -or (Get-ChildItem "$_.FullName\ndk-build*" -ErrorAction SilentlyContinue)) {
            Write-Output "Found NDK in subdirectory: $(.Name)"
            # Move contents up one level
            Write-Output "Moving contents..."
            Get-ChildItem "$_.FullName" -ErrorAction SilentlyContinue | Move-Item -Destination $ndkDir -Force
            Remove-Item "$_.FullName" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    if (Test-Path "$ndkDir\ndk-build.cmd") {
        Write-Output "NDK is ready to use!"
    } else {
        Write-Output "WARNING: NDK structure may need manual adjustment"
    }
}
