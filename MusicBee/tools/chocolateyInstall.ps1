$ErrorActionPreference = "Stop";
$packageName = "musicbee"
$installerType = "exe"
$silentArgs = "/S"
$url = "{{DownloadUrl}}"
$checksum = "{{Checksum}}"
$checksumType  = "sha256"
$validExitCodes = @(0)

$filename = [System.IO.Path]::GetFileNameWithoutExtension($url.Substring($url.LastIndexOf("/") + 1))
$zipFile = "$filename.zip"

$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "$packageName"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir $zipFile

Get-ChocolateyWebFile -PackageName "$packageName" `
                      -FileFullPath "$file" `
                      -Url "$url" `
                      -Checksum "$checksum" `
                      -ChecksumType "$checksumType"

Get-ChocolateyUnzip -FileFullPath "$file" `
                    -Destination "$tempDir" `
                    -PackageName "$packageName"

$exeFile = (Get-ChildItem $tempDir -Filter *.exe | Select-Object -First 1).FullName

Install-ChocolateyInstallPackage -PackageName "$packageName" `
                                 -FileType "$installerType" `
                                 -SilentArgs "$silentArgs" `
                                 -File "$exeFile" `
                                 -ValidExitCodes $validExitCodes