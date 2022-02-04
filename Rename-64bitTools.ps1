<#
.Synopsis
	Delete the 32-bit versions of the SysInternals tools and replace them with the 64-bit versions.

.Description
	Many SysInternals tools come in 32-bit versions (foo.exe) and 64-bit versions (foo64.exe).

The 32-bit versions have the more natural name, but don't get used on a 64-bit system.

This script deletes the 32-bit versions and renames the 64-bit versions to the more natural name.

.Parameter Path
	The path to the folder that contains the .exe files.
    If omitted, the script searches your $PATH to find where you installed the tools.

.Link
    https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite

#>

param (
	[Parameter(ValueFromPipeline)] [IO.DirectoryInfo] $Path
)


function Find-SysInternals {
    $path = $env:Path
    $pathdirs = $path -split ";"

    foreach ($dir in $pathdirs) {
        $pmPath = Join-Path -Path $dir -ChildPath "procmon.exe"

        if (Test-Path $pmPath) {
            return $dir
        }
    }

    return $null
}


function Rename-Files {
    param (
        [Parameter(Mandatory)] [String] $Directory
    )

    $files64 = Get-ChildItem -Path $Directory -Filter "*64.exe"

    foreach ($file64 in $files64) {
        $file32 = $file64.Name -replace '64.exe', '.exe'
        $path32 = $file64.FullName -replace '64.exe', '.exe'
    
        if (Test-Path $path32) {
            Remove-Item $path32
        }

        Rename-Item $file64.FullName $file32
    }

}


#
# Main script
#

$ErrorActionPreference = "Stop"

if ($PSBoundParameters.ContainsKey("Path")) {
    $dir = $Path.FullName
} else {
    $dir = Find-SysInternals

    if ($dir -eq $null) {
        Write-Error 'Can''t find SysInternals tools on $PATH. Please specify -Path.'
    }
}

Rename-Files -Directory $dir
