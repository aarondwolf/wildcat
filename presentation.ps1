# presentation.ps1
# This script bundles the core files for a Wildcat presentation into presentation.zip

$zipName = Join-Path $PSScriptRoot "presentation.zip"
# Move staging outside of the Dropbox/Sync folder to prevent locking issues
$stagingDir = Join-Path $env:TEMP "wildcat_staging_$(Get-Random)"

try {
    # Clean up any existing zip in the current directory
    if (Test-Path $zipName) { 
        Remove-Item $zipName -Force -ErrorAction SilentlyContinue 
    }

    # Create fresh staging directory
    New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null

    Write-Host "Staging files..."
    # Copy the demo and style files (placing them at the root of the zip)
    Copy-Item (Join-Path $PSScriptRoot "source/wildcat-demo.tex") -Destination (Join-Path $stagingDir "main.tex")
    Copy-Item (Join-Path $PSScriptRoot "source/*.sty") -Destination $stagingDir

    # Copy fonts (maintaining the Poppins and IBM_Plex_Sans folders)
    $fontsStaging = New-Item -ItemType Directory -Path (Join-Path $stagingDir "fonts")
    Copy-Item (Join-Path $PSScriptRoot "source/fonts/Poppins") -Destination $fontsStaging -Recurse
    Copy-Item (Join-Path $PSScriptRoot "source/fonts/IBM_Plex_Sans") -Destination $fontsStaging -Recurse

    Write-Host "Creating archive..."
    # Use -Path "$stagingDir/*" so the zip contents start at the root
    Compress-Archive -Path "$stagingDir/*" -DestinationPath $zipName -Force

    Write-Host "Successfully created presentation.zip with core files and open-source fonts."
}
catch {
    Write-Error "Failed to create presentation.zip: $($_.Exception.Message)"
}
finally {
    # Final cleanup of the random staging directory
    if (Test-Path $stagingDir) {
        Remove-Item -Recurse -Force $stagingDir -ErrorAction SilentlyContinue
    }
}
