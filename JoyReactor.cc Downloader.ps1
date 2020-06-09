[console]::WindowHeight=40
[console]::WindowWidth=70
[console]::BufferWidth=[console]::WindowWidth

# Version 1.0
# Required files in script folder - wget.exe, cookies.txt

function ConvertTo-Encoding ([string]$From, [string]$To){
  Begin{
    $encFrom = [System.Text.Encoding]::GetEncoding($from)
	$encTo = [System.Text.Encoding]::GetEncoding($to)
  }
  Process{
    $bytes = $encTo.GetBytes($_)
	$bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
	$encTo.GetString($bytes)
  }
}

Write-Host "Link for download: " -ForegroundColor Yellow -NoNewline
$Link = read-host
Write-Host "Name of created folder: JoyReactor_" -ForegroundColor Yellow -NoNewline
$Directory = read-host
$Directory = "JoyReactor_$Directory"
Write-Host "Begin from this page: " -ForegroundColor Yellow -NoNewline
[int]$StartingPage = read-host
Write-Host "End on this page: " -ForegroundColor Yellow -NoNewline
[int]$StopHere = read-host

for ($i = $StartingPage; $i -ge $StopHere; $i--){
 .\wget.exe `
  --load-cookies cookies.txt `
  --execute="robots=off" `
  --recursive `
  --level=1 `
  --convert-links `
  --span-hosts `
  --adjust-extension `
  --no-directories `
  --include-directories="/pics/post","/pics/comment","/pics/post/full","/pics/comment/full" `
  --exclude-directories="/post/tagBan","/post/spam","/post/delete","/pics/post/mp4","/pics/post/static" `
  --reject gif `
  --directory-prefix="$Directory" `
  --continue `
  --tries=10 `
  --read-timeout=20 `
  --wait=1 `
  --random-wait `
  --restrict-file-names=nocontrol `
  --local-encoding='utf-8' `
  --remote-encoding='utf-8' `
  "$Link/$i"

  Remove-Item $Directory\*.html
}

cd $Directory
Get-ChildItem -name | %{
  $NewName = $_ | ConvertTo-Encoding utf-8 windows-1251
  Rename-Item -Path "$_" -NewName "$NewName"
}

"`n`n`n"
Write-Host "Ready! " -NoNewline
Write-Host "[Enter] " -ForegroundColor Yellow -NoNewline
Write-Host "to exit: " -NoNewline
Read-Host
exit
