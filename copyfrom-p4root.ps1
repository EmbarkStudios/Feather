# Copies the plugin folder to here.
# $p4root is the Perforce root folder that contains the uproject file
param (
	[Parameter(Mandatory = $true)] 
	[string]$p4root
)

$files = git ls-tree -r --name-only embark | Select-String "^Script/Feather/|^Content/DebugInterface/"
$files | foreach {
	$dest = $_
	$src = (join-path $p4root $dest)
	if ((test-path $dest -PathType Leaf) -and (test-path $src)) {
		copy-item $src $dest
	}
}
