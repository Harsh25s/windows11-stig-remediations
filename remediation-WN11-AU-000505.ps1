<#
.SYNOPSIS
    Sets the maximum size of the Windows Security event log to at least 1024000 KB (1 GB).

.NOTES
    Author          : Harsh Sharma
    LinkedIn        : linkedin.com/in/harsh-sharma-hs33
    GitHub          : github.com/Harsh25s
    Date Created    : 2026-08-14
    Last Modified   : 2026-08-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000505
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-AU-000505/

.TESTED ON
    Date(s) Tested  : 2026-08-14
    Tested By       : Harsh Sharma
    Systems Tested  : Windows 11 Pro 23H2 (Azure VM)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated PowerShell session, then reboot and rescan in Tenable.
    Example syntax:
    PS C:\> .\remediation-WN11-AU-000505.ps1
#>

$RegPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
$Name     = "MaxSize"
$Value    = 1024000
$Type     = "DWord"

# Create the key if it does not exist
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
    Write-Host "Created registry key: $RegPath"
}

# Apply the setting
New-ItemProperty -Path $RegPath -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
Write-Host "WN11-AU-000505 applied: $Name = $Value"

# Verify
$Current = (Get-ItemProperty -Path $RegPath -Name $Name -ErrorAction SilentlyContinue).$Name
if ($Current -eq $Value) {
    Write-Host "VERIFIED - WN11-AU-000505 is compliant (current value: $Current)" -ForegroundColor Green
} else {
    Write-Host "FAILED - WN11-AU-000505 did not apply correctly (current value: $Current)" -ForegroundColor Red
}
