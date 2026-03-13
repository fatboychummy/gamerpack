# Path to the file containing the build number
$buildFile = "build.txt"

# Read current build number
$buildNumber = Get-Content $buildFile
$newBuild = [int]$buildNumber + 1

Write-Output "Current Build: $buildNumber"
Write-Output "New Build: $newBuild"

# Generate the packwiz zips
try {
    mkdir "builds/$newBuild" -ErrorAction SilentlyContinue
    
    Write-Output "### Packwiz Refresh ###"
    packwiz refresh
    
    Write-Output "### Export Both ###"
    packwiz curseforge export -s both -o "builds/$newBuild/both.zip"

    Write-Output "### Export Server ###"
    packwiz curseforge export -s server -o "builds/$newBuild/server.zip"

    Write-Output "### Export Client ###"
    packwiz curseforge export -s client -o "builds/$newBuild/client.zip"
} catch {
    Write-Host "Error generating zips: $($_.Exception.Message)"
    exit 1
}