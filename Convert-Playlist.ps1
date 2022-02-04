<#
.Synopsis
	Convert a Windows Media Player playlist into an Apple Music (iTunes) playlist.

.Description
	This command reads a Windows Media Player playlist file in .asx format. It writes a .txt file in tab-separated CSV format with Apple's standard columns.

Windows Media playlists and Apple playlists have very few fields in common. Only the Title and Location are carried over.

Notes:

If you copy the .txt playlist to your Mac or iPhone, the location will only be valid for URLs, i.e. Internet audio streams. Local file paths are inherently different between Windows and MacOS. Perhaps a future version of this script will allow for basic path conversions.

Windows Media Player tolerates certain malformed XML in .asx files. For example, <ASX>, <asx>, and <Asx> are all accepted; so are unescaped & characters in song titles. A minimal allowance is made for the case insensitive element tags. An unescaped & simply breaks the XML parser. If this affects you, I'm sorry, but it's faster for you to edit your playlist files by hand than for me to write code to deal with it in the script.

.Parameter Playlist
	The path to the .asx file.

.Parameter Output
	The path to the output .txt file.
    By default, it is the name of the input file with .asx replaced by .txt.


.Example
	PS>  Convert-Playlist -Playlist "C:\music\playlists\mystreams.asx"

	Reads the entries in mystreams.asx and writes them to mystreams.txt.

.Link
    https://docs.microsoft.com/en-us/windows/win32/wmp/creating-metafile-playlists

.Link
	https://docs.microsoft.com/en-us/windows/win32/wmp/metafile-playlists

.Link
    https://docs.microsoft.com/en-us/windows/win32/wmp/windows-media-metafile-reference

#>

param (
	[Parameter(Mandatory=$true,  Position=0)] [ValidateNotNullOrEmpty()] [string] $Playlist,
	[Parameter(Mandatory=$false, Position=1)]                            [string] $Output
)

$inputFile = Resolve-Path $Playlist

if (-not (Test-Path variable:Output) -or ($Output -eq $null) -or ($Output.Length -eq 0)) {
    $Output = [io.path]::ChangeExtension($inputFile, ".txt")
}

$outputFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Output)
Write-Host "Writing playlist to" $outputFile

$xpaths = @(
    '/asx/entry', '/asx/Entry', '/asx/ENTRY',
    '/Asx/entry', '/Asx/Entry', '/Asx/ENTRY',
    '/ASX/entry', '/ASX/Entry', '/ASX/ENTRY'
)

$outputObjects = @()

$xml = [xml](Get-Content -LiteralPath $inputFile)

foreach ($xpath in @($xpaths)) {
    $entryNodes = $xml.SelectNodes($xpath)
    foreach ($entryNode in $entryNodes) {

        $title = $entryNode.title
        $href = $entryNode.ref.href

        $outputObject = [pscustomobject] [ordered] @{
            'Name' = $title
            'Artist' = ""
            'Composer' = ""
            'Album' = ""
            'Grouping' = ""
            'Work' = ""
            'Movement Number' = ""
            'Movement Count' = ""
            'Movement Name' = ""
            'Genre' = ""
            'Size' = ""
            'Time' = ""
            'Disc Number' = ""
            'Disc Count' = ""
            'Track Number' = ""
            'Track Count' = ""
            'Year' = ""
            'Date Modified' = ""
            'Date Added' = ""
            'Bit Rate' = ""
            'Sample Rate' = ""
            'Volume Adjustment' = ""
            'Kind' = ""
            'Equalizer' = ""
            'Comments' = ""
            'Plays' = ""
            'Last Played' = ""
            'Skips' = ""
            'Last Skipped' = ""
            'My Rating' = ""
            'Location' = $href
        }

        $outputObjects += $outputObject
    }
}

$outputObjects | Export-Csv -LiteralPath $outputFile -NoTypeInformation -Delimiter "`t" -UseQuotes Never
