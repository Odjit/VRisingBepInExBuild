# BepInEx Download, Extract, and Package Script

# Step 1: Run the PowerShell script located in \BepInEx\build.ps1
Write-Host "Running BepInEx build script..."
try {
    # Save current location
    $originalLocation = Get-Location
    
    # Change to the BepInEx directory
    Set-Location -Path ".\BepInEx"
    
    # Run the build script
    & '.\build.ps1'
    
    # Check exit code
    if ($LASTEXITCODE -ne 0) {
        # Return to original location before exiting
        Set-Location -Path $originalLocation
        Write-Error "The build script failed with exit code $LASTEXITCODE"
        exit 1
    }
    
    # Return to original location
    Set-Location -Path $originalLocation
} catch {
    # Make sure we return to the original location even if there's an error
    if ($originalLocation) {
        Set-Location -Path $originalLocation
    }
    Write-Error "Failed to run the build script: $_"
    exit 1
}
Write-Host "Build script completed successfully." -ForegroundColor Green

# Step 2: Download BepInEx zip file
$url = "https://builds.bepinex.dev/projects/bepinex_be/733/BepInEx-Unity.IL2CPP-win-x64-6.0.0-be.733%2B995f049.zip"
$downloadPath = ".\BepInEx-download.zip"
Write-Host "Downloading BepInEx from $url..."
try {
    Invoke-WebRequest -Uri $url -OutFile $downloadPath
    if (!(Test-Path $downloadPath)) {
        Write-Error "Download failed, file not found: $downloadPath"
        exit 1
    }
} catch {
    Write-Error "Failed to download BepInEx: $_"
    exit 1
}
Write-Host "Download completed successfully." -ForegroundColor Green

# Step 3: Extract the zip to BepInEx_V-Rising_1.1 folder
$extractPath = ".\BepInEx_V-Rising_1.1"
Write-Host "Extracting files to $extractPath..."
try {
    # Create the extraction directory if it doesn't exist
    if (!(Test-Path $extractPath)) {
        New-Item -Path $extractPath -ItemType Directory | Out-Null
    } else {
        # Clear the directory if it exists
        Get-ChildItem -Path $extractPath -Recurse | Remove-Item -Force -Recurse
    }
    
    # Extract the zip file
    Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
} catch {
    Write-Error "Failed to extract the zip file: $_"
    exit 1
}
Write-Host "Extraction completed successfully." -ForegroundColor Green

# Step 4: Copy files from BepInEx\bin\Unity.IL2CPP to BepInEx_V-Rising_1.1\BepInEx\core
$sourceDir = ".\BepInEx\bin\Unity.IL2CPP"
$destDir = "$extractPath\BepInEx\core"
Write-Host "Copying files from $sourceDir to $destDir..."
try {
    # Create the destination directory if it doesn't exist
    if (!(Test-Path $destDir)) {
        New-Item -Path $destDir -ItemType Directory -Force | Out-Null
    }
    
    # Copy all files (not recursing into folders)
    Get-ChildItem -Path $sourceDir -File | Copy-Item -Destination $destDir -Force
} catch {
    Write-Error "Failed to copy files: $_"
    exit 1
}
Write-Host "Files copied successfully." -ForegroundColor Green

# Step 5: Create a new zip file with the contents of BepInEx_V-Rising_1.1
$finalZipPath = ".\BepInEx_V-Rising_1.1.zip"
Write-Host "Creating final zip file $finalZipPath..."
try {
    # Remove the existing zip file if it exists
    if (Test-Path $finalZipPath) {
        Remove-Item -Path $finalZipPath -Force
    }
    
    # Create the zip file with the contents of the folder
    # Changing to the directory first to avoid including the path in the zip
    Push-Location $extractPath
    try {
        Compress-Archive -Path .\* -DestinationPath ..\$finalZipPath -Force
    } finally {
        Pop-Location
    }
} catch {
    Write-Error "Failed to create the final zip file: $_"
    exit 1
}
Write-Host "Final zip file created successfully: $finalZipPath" -ForegroundColor Green

# Clean up the downloaded zip file
Remove-Item -Path $downloadPath -Force

Write-Host "All operations completed successfully!" -ForegroundColor Green