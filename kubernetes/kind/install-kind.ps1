# alternative installation using Chocolatey
# choco install kind

# Find latest versions number based on tags on remote repo
$regex = '([0-9]+.[0-9]+.[0-9]+$)'
$version = git ls-remote --tags https://github.com/kubernetes-sigs/kind.git | Select-String $regex -AllMatches | Select-Object -Expand Matches | ForEach-Object { $_.Value } `
    | ForEach-Object {[System.Version]$_} | Sort-Object | Select-Object -Last 1 | ForEach-Object {[string] $_}
Write-Output "Latest version found: $version"
# $version = "v0.20.0"

# Define target path and download selected binary version
$addPath = "c:\dev"
Invoke-WebRequest -Uri https://kind.sigs.k8s.io/dl/v$version/kind-windows-amd64 -OutFile  c:\dev\kind.exe

# Add target path to the environment if not exists
if (Test-Path $addPath){
    $regexAddPath = [regex]::Escape($addPath)
    $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
    $env:Path = ($arrPath + $addPath) -join ';'
} else {
    Throw "'$addPath' is not a valid path."
}
