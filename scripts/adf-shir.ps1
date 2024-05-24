
if ((Test-Path "C:\Program Files\PowerShell\7\pwsh.exe") -eq $false) {
    $pwshurl = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/PowerShell-7.4.2-win-x64.msi"
    $downloadPath = "$env:TEMP\PowerShell-7.4.2-win-x64.msi"
    Invoke-WebRequest -Uri $pwshurl -OutFile $downloadPath
    if (-not (Test-Path $downloadPath)) {
        Write-Error "Failed to download PowerShell MSI."
        exit 1
    }

    $cmd="/package $downloadPath /quiet `
        ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=0 `
        ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=0 `
        ENABLE_PSREMOTING=0 `
        REGISTER_MANIFEST=1 `
        USE_MU=1 `
        ENABLE_MU=1 `
        ADD_PATH=1"

    $process = Start-Process  "msiexec.exe" -ArgumentList $cmd -Wait -NoNewWindow -PassThru
    if ($process.ExitCode -ne 0)
    {
        throw "Failed to install pwsh. msiexec exit code: $($process.ExitCode)"
        exit 1
    }
    Remove-Item $downloadPath
}

$installed=$(pwsh -Command "Get-InstalledModule -Name Az.DataFactory -ErrorAction SilentlyContinue")
if ($null -eq $installed) {
    pwsh -Command "
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Install-Module -Name Az -AllowClobber -Scope AllUsers -Force
    "
}


$downloadPath = "$env:TEMP\IntegrationRuntime_5.41.8888.1.msi"
if ((Test-Path $downloadPath) -eq $false) {
    $irurl="https://download.microsoft.com/download/E/4/7/E4771905-1079-445B-8BF9-8A1A075D8A10/IntegrationRuntime_5.41.8888.1.msi"
    Invoke-WebRequest -Uri $irurl -OutFile $downloadPath
    if (-not (Test-Path $downloadPath)) {
        Write-Error "Failed to download shir MSI."
        exit 1
    }
}

$process = Start-Process "msiexec.exe" "/i $downloadPath /quiet /passive" -Wait -PassThru
if ($process.ExitCode -ne 0)
{
    throw "Failed to install Microsoft Integration Runtime. msiexec exit code: $($process.ExitCode)"
}
