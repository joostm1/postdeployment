
$pwshurl = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/PowerShell-7.4.2-win-x64.msi"

# Download & install pwsh
$downloadPath = "$env:TEMP\PowerShell-7.4.2-win-x64.msi"
Invoke-WebRequest -Uri $pwshurl -OutFile $downloadPath

# Check if download was successful
if (-not (Test-Path $downloadPath)) {
    Write-Error "Failed to download PowerShell MSI."
    exit 1
}

# Install pwsh
msiexec.exe /package $downloadPath /quiet `
    ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=0 `
    ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=0 `
    ENABLE_PSREMOTING=0 `
    REGISTER_MANIFEST=1 `
    USE_MU=1 `
    ENABLE_MU=1 `
    ADD_PATH=1


    