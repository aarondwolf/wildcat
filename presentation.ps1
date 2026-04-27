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
    Copy-Item (Join-Path $PSScriptRoot "source/logo-northwestern.pdf") -Destination $stagingDir

    # Copy demo graph outputs used by main.tex.
    $graphsStaging = New-Item -ItemType Directory -Path (Join-Path $stagingDir "graphs")
    Copy-Item (Join-Path $PSScriptRoot "source/graphs/plot-*.pdf") -Destination $graphsStaging

    Write-Host "Creating archive..."
    # Use -Path "$stagingDir/*" so the zip contents start at the root
    Compress-Archive -Path "$stagingDir/*" -DestinationPath $zipName -Force

    Write-Host "Successfully created presentation.zip with core files, logo, and demo graph PDFs."
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
