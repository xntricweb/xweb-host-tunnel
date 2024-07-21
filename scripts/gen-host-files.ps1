param (
    [parameter(Mandatory=$false)]
    [PSDefaultValue(Help="./secrets in current directory")]
    [String]$dest = "$(
        $MyInvocation.MyCommand.Definition|split-path|split-path
        )/secrets",
    
    [parameter(Mandatory=$false)]
    [PSDefaultValue(Help="SERVER_IP placeholder for manual fill in")]
    [string]$IP = "SERVER_IP"
)

$root=$MyInvocation.MyCommand.Definition|split-path|split-path
$destrel=$dest|resolve-path -ErrorAction Ignore -Relative -RelativeBasePath $root

Set-Location "$root"

Write-Debug("Putting keys here: $Dest")
Write-Debug("Creating container")
$id = docker create xweb-host-tunnel gen-host-files "$($destrel -replace "\\","/")" "$IP"
Write-Debug("Generating keys")
docker start -ai $id
docker cp "${id}:/tmp/host-files/." "$dest" | Out-Null

Write-Debug("Removing container")
docker rm $id | Out-Null
