# c1keywords
Push CaptureOne keywords into IPTC Description field because CaptureOne won't.

CaptureOne won't allow you to use Keywords in filename exports, but only has a nice GUI for adding keywords to files - Editing metadata is a pain in the arse.
As a consequence I end up with keyworded files, and no way to meaningfully name exported files.

Installation:
 * Create folder %USERPROFILE%\.keyswap , and add it to your PATH envvar:
 * * C:\> setx path "%PATH%;C:\path\to\directory\"
 * Add all files from repository to the folder you just created above.

Usage:
 * Select all files in C1, hit Ctrl+S to save metadata to XMP files.
 * Close C1.
 * Open a powershell prompt and navigate to the session capture/selects folder, wherever your RAW files are hiding.
 * Run the following PS command:

```

Get-ChildItem -Path "." -Filter *.xmp |
ForEach-Object {
  keyswap.bat $_.DirectoryName $_.Name}
}

```

This will create a backup folder containing the original XMPs, and amend the XMPs in the capture folder accordingly.

USE AT OWN RISK. Ideally do this operation as a first step before creating complex edits.
