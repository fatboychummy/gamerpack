# Path to the file containing the build number
$buildFile = "build.txt"

# Read current build number
$buildNumber = Get-Content $buildFile
$newBuild = [int]$buildNumber + 1

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
git push origin main
git push origin $tagName

Write-Host "Release $tagName created and pushed successfully."
