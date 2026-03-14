# Path to the file containing the build number
$buildFile = "build.txt"

# Read current build number
$buildNumber = Get-Content $buildFile
$newBuild = [int]$buildNumber + 1

Write-Output "Current Build: $buildNumber"
Write-Output "New Build: $newBuild"

# Generate the packwiz zips
try {
    # Ensure the directory is empty
    if (Test-Path "builds/$newBuild") {
        Remove-Item "builds/$newBuild" -Recurse -Force
    }
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

# Write new build number
Set-Content $buildFile $newBuild
Write-Host "Updated build number to $newBuild"

# Commit the change
git add $buildFile
git commit -m "Bump build number to $newBuild"
Write-Host "Committed build number bump"

# Create a git tag (change 'v' if you want no prefix)
$tagName = "b_$newBuild"
git tag $tagName
Write-Host "Created $tagName"

# Push branch + tag
git push origin master
git push origin $tagName

Write-Host "Release $tagName created and pushed successfully."
