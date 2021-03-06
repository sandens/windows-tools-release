﻿$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

$mtx = New-Object System.Threading.Mutex($false, "PathMutex")

if (!$mtx.WaitOne(300000)) {
  throw "Could not acquire PATH mutex"
}

$logDir = "c:\var\vcap\sys\log\az"
$path=(Get-ChildItem "c:\var\vcap\packages\az\azure-cli-*.msi").FullName
$installDir = "c:\var\vcap\data\az"

Start-Process -FilePath msiexec -ArgumentList "/i $path SDKFOLDER=$installDir /qn /lxv $logDir\install.log" -Wait -PassThru -NoNewWindow

$mtx.ReleaseMutex()
