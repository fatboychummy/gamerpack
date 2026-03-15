try {
    Write-Output "### Packwiz Refresh ###"
    packwiz refresh
} catch {
    Write-Host "Error refreshing: $($_.Exception.Message)"
    exit 1
}