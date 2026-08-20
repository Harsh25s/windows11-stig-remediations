<#
.SYNOPSIS
    Disables WDigest Authentication so plaintext credentials are not cached in LSASS memory.

.NOTES
    Author          : Harsh Sharma
    LinkedIn        : linkedin.com/in/harsh-sharma-hs33
    GitHub          : github.com/Harsh25s
    Date Created    : 2026-08-19
    Last Modified   : 2026-08-19
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000038
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-CC-000038/

.TESTED ON
    Date(s) Tested  : 2026-08-19
    Tested By       : Harsh Sharma
    Systems Tested  : Windows 11 Pro 23H2 (Azure VM)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated PowerShell session, then reboot and rescan in Tenable.
    Example syntax:
    PS C:\> .\remediation-WN11-CC-000038.ps1

.WHY THIS MATTERS
    When UseLogonCredential is enabled, WDigest stores credentials in LSASS in a reversible
    form, allowing credential-dumping tools to recover plaintext passwords from memory.
    Setting it to 0 forces Windows to omit those credentials from LSASS entirely.
#>

$RegPath  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest"
$Name     = "UseLogonCredential"
$Value    = 0
$Type     = "DWord"

# Create the key if it does not exist
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
    Write-Host "Created registry key: $RegPath"
}

# Apply the setting
New-ItemProperty -Path $RegPath -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
Write-Host "WN11-CC-000038 applied: $Name = $Value"

# Verify
$Current = (Get-ItemProperty -Path $RegPath -Name $Name -ErrorAction SilentlyContinue).$Name
if ($Current -eq $Value) {
    Write-Host "VERIFIED - WN11-CC-000038 is compliant (current value: $Current)" -ForegroundColor Green
} else {
    Write-Host "FAILED - WN11-CC-000038 did not apply correctly (current value: $Current)" -ForegroundColor Red
}
