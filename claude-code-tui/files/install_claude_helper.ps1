<#
.SYNOPSIS
    Headless installation helper for Claude Code TUI agent.
.DESCRIPTION
    Executes Anthropic's install.ps1 and relocates extracted binaries from
    Session 0 systemprofile to the global installation root.
#>
param (
    [Parameter(Mandatory = $true)]
    [string]$InstallScriptPath,
    [Parameter(Mandatory = $true)]
    [string]$InstallRoot
)

$ErrorActionPreference = 'Stop'

& powershell.exe -ExecutionPolicy Bypass -File $InstallScriptPath

$SysBase = "$env:SystemRoot\System32\config\systemprofile\.local"
$SysBin = Join-Path $SysBase "bin\claude.exe"
$SysShare = Join-Path $SysBase "share\claude"

if (Test-Path $SysBin) {
    if (-not (Test-Path $InstallRoot)) {
        New-Item `
            -Force `
            -ItemType Directory `
            -Path $InstallRoot | Out-Null
    }
    $TargetExe = Join-Path $InstallRoot "claude.exe"
    Copy-Item -Destination $TargetExe -Force -Path $SysBin
    if (Test-Path $SysShare) {
        $TargetShare = Join-Path $InstallRoot "share"
        Copy-Item -Destination $TargetShare -Force -Recurse -Path $SysShare
    }
}
