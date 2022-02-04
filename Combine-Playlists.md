# Combine-Playlists

Combines multiple Windows Media Player playlists into one.

## Syntax

``` powershell
Combine-Playlists.ps1 [[-Path] <DirectoryInfo>] [[-Filter] <String>] [[-Output] <String>] [[-Title] <String>] [<CommonParameters>]
```

## Description
This PowerShell script combines multiple `.asx` playlist files into a single `.asx` playlist file.

Windows Media Player tolerates certain malformed XML in `.asx` files. For example, `<ASX>`, `<asx>`, and `<Asx>` are all accepted; so are unescaped `&` characters in song titles.

A minimal allowance is made for the case insensitive element tags.

An unescaped `&` simply breaks the XML parser. If this affects you, I'm sorry, but it's faster for you to edit your playlist files by hand than for me to write code to deal with it in the script.

## Parameters

``` powershell
-Path <DirectoryInfo>
```

The path to the folder that contains `.asx` files.
By default, it is the current directory.

|                             |       |
|-----------------------------|-------|
| Required?                   | false |
| Position?                   | 1     |
| Default value               | .     |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |


``` powershell
-Filter <String>
```

A wildcard filter for the input files.
By default, it is `*.asx`

|                             |       |
|-----------------------------|-------|
| Required?                   | false |
| Position?                   | 2     |
| Default value               | *.asx |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

``` powershell
-Output <String>
```

The path to the output file.
By default, it is `Combined.asx` in the current directory.

|                             |       |
|-----------------------------|-------|
| Required?                   | false |
| Position?                   | 3     |
| Default value               | .\Combined.asx |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

``` powershell
-Title <String>
```

The title of the combined playlist.
By default, it is the name of the output file.

|                             |       |
|-----------------------------|-------|
| Required?                   | false |
| Position?                   | 4     |
| Default value               |       |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

``` powershell
<CommonParameters>
```

This cmdlet supports the common parameters: `Verbose`, `Debug`, `ErrorAction`, `ErrorVariable`, `WarningAction`, `WarningVariable`, `OutBuffer`, `PipelineVariable`, and `OutVariable`. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## Examples

### Example 1

``` powershell
Combine-Playlists
```

Combines all the playlists in the current directory into a single playlist called "Combined." The playlist is saved as `.\Combined.asx`.

### Example 2

``` powershell
Combine-Playlists -Path "C:\music\playlists" -Output "My Music.asx"
```

Combines all the playlists in `C:\music\playlists` into a single playlist called "My Music." The playlist is saved as `.\My Music.asx`.

### Example 3

``` powershell
Combine-Playlists -Path "C:\music\playlists" -Output "C:\music\playlists\everything.asx" -Title "One Big Playlist"
```

Combines all the playlists in `C:\music\playlists` into a single playlist called "One Big Playlist." The playlist is saved as `C:\music\playlists\everything.asx`.

## Related Links
* https://docs.microsoft.com/en-us/windows/win32/wmp/creating-metafile-playlists
* https://docs.microsoft.com/en-us/windows/win32/wmp/metafile-playlists
* https://docs.microsoft.com/en-us/windows/win32/wmp/windows-media-metafile-reference
