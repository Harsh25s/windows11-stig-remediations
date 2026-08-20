# DISA STIG Remediations — Windows 11 (v2r7)

PowerShell remediation scripts for ten Windows 11 DISA STIG findings, written for the
LogN Pacific Cyber Range Vulnerability Management internship track.

Each script is idempotent: it creates the registry key if absent, applies the setting,
then reads the value back and reports VERIFIED or FAILED before exiting.

All ten controls below were confirmed **Failed** in a baseline Tenable compliance scan and
**Passed** after remediation and reboot, using the `DISA Microsoft Windows 11 STIG v2r7`
audit file against a Windows 11 Pro 23H2 Azure VM.

## Controls remediated

| # | STIG-ID | Control | Registry value |
|---|---------|---------|----------------|
| 1 | [WN11-AU-000500](remediation-WN11-AU-000500.ps1) | Application event log ≥ 32 MB | `MaxSize = 32768` |
| 2 | [WN11-AU-000510](remediation-WN11-AU-000510.ps1) | System event log ≥ 32 MB | `MaxSize = 32768` |
| 3 | [WN11-CC-000005](remediation-WN11-CC-000005.ps1) | Camera disabled on lock screen | `NoLockScreenCamera = 1` |
| 4 | [WN11-CC-000038](remediation-WN11-CC-000038.ps1) | WDigest Authentication disabled | `UseLogonCredential = 0` |
| 5 | [WN11-CC-000180](remediation-WN11-CC-000180.ps1) | AutoPlay off for non-volume devices | `NoAutoplayfornonVolume = 1` |
| 6 | [WN11-CC-000185](remediation-WN11-CC-000185.ps1) | AutoRun commands blocked | `NoAutorun = 1` |
| 7 | [WN11-CC-000190](remediation-WN11-CC-000190.ps1) | AutoPlay off for all drives | `NoDriveTypeAutoRun = 255` |
| 8 | [WN11-CC-000310](remediation-WN11-CC-000310.ps1) | Users cannot change install options | `EnableUserControl = 0` |
| 9 | [WN11-CC-000315](remediation-WN11-CC-000315.ps1) | AlwaysInstallElevated disabled | `AlwaysInstallElevated = 0` |
| 10 | [WN11-CC-000326](remediation-WN11-CC-000326.ps1) | PowerShell script block logging on | `EnableScriptBlockLogging = 1` |

## Usage

Run elevated on the target system:

```powershell
cd C:\STIG
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Get-ChildItem .\remediation-*.ps1 | ForEach-Object { & $_.FullName }
Restart-Computer
```

A reboot is required before rescanning — the event log sizing and Windows Installer
policies are not read as compliant until the system restarts.

## Method

Following the internship methodology:

1. Baseline authenticated compliance scan (Tenable, DISA Windows 11 STIG v2r7)
2. Identify failed findings and locate the corresponding registry controls
3. Remediate manually, confirm the fix, then automate in PowerShell
4. Reboot and rescan to confirm each finding moves from Failed to Passed

The baseline scan itself serves as the failing-state evidence, so no revert cycle is
required to demonstrate before/after.

## Scan environment

| Item | Value |
|------|-------|
| Target | Windows 11 Pro 23H2, Azure VM |
| Scanner | Tenable Vulnerability Management, LOCAL-SCAN-ENGINE-01 |
| Audit file | `DISA_STIG_Microsoft_Windows_11_v2r7.audit` |
| Scan type | Advanced Network Scan, credentialed |

Credentialed scanning required Remote Registry running and
`LocalAccountTokenFilterPolicy = 1` on the target. Both are scan prerequisites, not
hardening steps, and should be reverted on production systems once scanning completes.

## Author

Harsh Sharma — [LinkedIn](https://www.linkedin.com/in/harsh-sharma-hs33) · [GitHub](https://github.com/Harsh25s)
