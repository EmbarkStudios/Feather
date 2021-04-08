# Copies the workspace to the Plugins\Marketplace folder under $p4root.
# $p4root is the Perforce root folder that contains the uproject file
param (
	[Parameter(Mandatory = $true)] 
	[string]$p4root
)

$pluginName = "Feather"
$pluginRoot = join-path $p4root "Script\$pluginName"

$files = (git ls-tree -r --name-only embark) | Select-String "\.ps1$" -NotMatch | Select-String "^Build-Scripts" -NotMatch
$files | foreach {
	$src = $_
	if (test-path $src -PathType Leaf) {
		$dest = (join-path $pluginRoot $src)
		(New-Item -Path (Split-Path -Path $dest) -Type Directory -ErrorAction SilentlyContinue)
		copy-item $src $dest
	}
}

$sha = (git rev-parse HEAD)
$origin = (git remote get-url --push origin)
$branch = (git branch --show-current)

$infoPath = (join-path $pluginRoot "PLUGIN_ORIGIN.json")
if (Test-Path $infoPath) {
	remove-item $infoPath
}

$pluginOrigin = New-Item -ItemType File -Path $infoPath
"{" >> $pluginOrigin
"  `"origin`": `"$origin`"," >> $pluginOrigin
"  `"branch`": `"$branch`"," >> $pluginOrigin
"  `"commit`": `"$sha`"" >> $pluginOrigin
"}" >> $pluginOrigin
