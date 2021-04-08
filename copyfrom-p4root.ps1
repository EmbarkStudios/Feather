# Copies the plugin folder to here.
# $p4root is the Perforce root folder that contains the uproject file
param (
	[Parameter(Mandatory = $true)] 
	[string]$p4root
)

$pluginName = "Feather"
$pluginRoot = join-path $p4root "Script\$pluginName"

$files = git ls-tree -r --name-only embark
$files | foreach {
	$dest = $_
	$src = (join-path $pluginRoot $dest)
	if ((test-path $dest -PathType Leaf) -and (test-path $src)) {
		copy-item $src $dest
	}
}