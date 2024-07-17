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
# foreach($file in $files) {
#     Write-Debug("Copying key: $file")
# }
Write-Debug("Removing container")
docker rm $id | Out-Null

# $names = $files -split "`n"|split-path -Leaf
# $hostkeys = $names -match '^ssh_host'
# $ids = $names -match '^id'


# Write-Debug "Generating known_hosts file"
# $hostkeys -match '\.pub$'
#     |foreach{"$IP $(get-content "$dest\$_")"}
#     |join-string -separator "`n"
#     |out-file "$dest\known_hosts"

# Write-Debug "Generating authorized_keys file"
# $ids -match '\.pub$'
#     |foreach{get-content "$dest\$_"}
#     |join-string -separator "`n"
#     |out-file "$dest\authorized_keys"

# mkdir -force "$root/templates" | out-null
# Write-Debug("Generating Compose Template")
# "
# services:
#     tunnel:
#         image: xweb-host-tunnel
#         environment:
#             - ""HOST_KEY_FILE_GLOB=/etc/ssh/*_key*""
            
#         secrets:$($names|foreach {"
#             - $_"})

# secrets:$($names|foreach {"
#     ${_}:
#         file: $($destrel -replace '\\','/')/$_"}
#     )
# " -replace "`r" | out-file "$root/templates/compose.server.yaml"
# $(
# foreach($file in $files) {"
#     $(($file | split-path -leaf)):
#         file: $("$Dest\$($file|split-path -leaf)"|Resolve-Path -relative)"
# })" -replace '\r' 
