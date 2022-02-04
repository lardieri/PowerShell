<#
.Synopsis
	Combines multiple Windows Media Player playlists into one.

.Description
	This command combines multiple .asx playlist files into a single .asx playlist file.

Windows Media Player tolerates certain malformed XML in .asx files. For example, <ASX>, <asx>, and <Asx> are all accepted; so are unescaped & characters in song titles.

A minimal allowance is made for the case insensitive element tags.

An unescaped & simply breaks the XML parser. If this affects you, I'm sorry, but it's faster for you to edit your playlist files by hand than for me to write code to deal with it in the script.

.Parameter Path
	The path to the folder that contains .asx files.
    By default, it is the current directory.

.Parameter Output
	The path to the output file.
    By default, it is "Combined.asx" in the current directory.

.Parameter Filter
	A wildcard filter for the input files.
    By default, it is "*.asx"

.Parameter Title
    The title of the combined playlist.
    By default, it is the name of the output file.

.Example
	PS>  Combine-Playlists

	Combines all the playlists in the current directory into a single playlist called "Combined"
    The playlist is saved as .\Combined.asx

.Example
	PS>  Combine-Playlists -Path "C:\music\playlists" -Output "My Music.asx"

	Combines all the playlists in C:\music\playlists into a single playlist called "My Music"
    The playlist is saved as .\My Music.asx

.Example
	PS>  Combine-Playlists -Path "C:\music\playlists" -Output "C:\music\playlists\everything.asx" -Title "One Big Playlist"

	Combines all the playlists in C:\music\playlists into a single playlist called "One Big Playlist"
    The playlist is saved as C:\music\playlists\everything.asx

.Link
    https://docs.microsoft.com/en-us/windows/win32/wmp/creating-metafile-playlists

.Link
	https://docs.microsoft.com/en-us/windows/win32/wmp/metafile-playlists

.Link
    https://docs.microsoft.com/en-us/windows/win32/wmp/windows-media-metafile-reference

#>
param (
	[IO.DirectoryInfo]$Path = ".",
	[string]$Filter = "*.asx",
	[string]$Output = ".\Combined.asx",
    [string]$Title
)

$xpaths = @(
    '/asx/entry', '/asx/Entry', '/asx/ENTRY',
    '/Asx/entry', '/Asx/Entry', '/Asx/ENTRY',
    '/ASX/entry', '/ASX/Entry', '/ASX/ENTRY'
)

$inputDir = Resolve-Path $Path
$outputFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Output)

$outputXml = [xml] @"
<asx version="3.0">
</asx>
"@

if (-not (Test-Path variable:Title) -or ($Title -eq $null) -or ($Title.Length -eq 0)) {
    $Title = [io.path]::GetFileNameWithoutExtension($outputFile)
}

$outputNode = $outputXml.SelectSingleNode('/asx')
$outputNode.PrependChild($outputXml.CreateElement("title")).InnerText = $Title

Write-Host -InformationAction Inquire "Create playlist" $Title "in" $outputFile "by combining playlists in" $inputDir "?"

$files = Get-ChildItem -Path $inputDir -Filter $Filter

foreach ($file in $files) {
    Write-Host "Processing" $file.FullName
    $xml = [xml](Get-Content -LiteralPath $file.PSPath)

    foreach ($xpath in @($xpaths)) {
        $entryNodes = $xml.SelectNodes($xpath)
        foreach ($entryNode in $entryNodes) {
            $newEntryNode = $outputXml.ImportNode($entryNode, $true)
            [void] $outputNode.AppendChild($newEntryNode)
        }
    }
}

$outputXml.Save($outputFile)