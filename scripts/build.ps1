
$root = split-path -parent $MyInvocation.MyCommand.Definition
docker build $root/.. -t xweb-host-tunnel 