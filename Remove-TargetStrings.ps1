<#
.Synopsis
	Remove <Target> strings from an XLIFF file.

.Description
	This command reads an XLIFF file and removes the contents of any <Target> nodes. It does not remove the nodes themselves.

.Parameter In
	The path to the original XLIFF file.

.Parameter Output
	The path to the output (modified XLIFF) file.

.Example
	PS>  Remove-TargetStrings -In "./fr.xcloc/Localized Contents/fr.xliff" -Out "./fr-empty-targets.xliff"
#>

param (
	[Parameter(Mandatory=$true, Position=0)] [ValidateNotNullOrEmpty()] [string] $In,
	[Parameter(Mandatory=$true, Position=1)] [ValidateNotNullOrEmpty()] [string] $Out
)

$inputFile = Resolve-Path $In
$outputFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Out)

$xml = [xml](Get-Content -LiteralPath $inputFile)

$namespaceURI = $xml.DocumentElement.NamespaceURI
$namespaceManager = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$namespaceManager.AddNamespace("ns", $namespaceURI)

$targetPath = '/ns:xliff//ns:trans-unit/ns:target'
$targets = $xml.SelectNodes($targetPath, $namespaceManager)

foreach ($target in $targets) {
    # $targetText = $target.InnerText
    # Write-Host "Removing target string: $targetText"

    $target.InnerText = ""
}

$xml.Save($outputFile)
