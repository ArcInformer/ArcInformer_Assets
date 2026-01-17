# PowerShell script to generate all_items.json from all item JSON files

# Set the paths
$itemsFolder = Join-Path $PSScriptRoot "Data\items"
$outputFolder = Join-Path $PSScriptRoot "Data\ArcInformer"
$outputFile = Join-Path $outputFolder "all_items.json"

# Ensure the output folder exists
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
    Write-Host "Created directory: $outputFolder"
}

# Get all JSON files from the items folder
$jsonFiles = Get-ChildItem -Path $itemsFolder -Filter "*.json" -File

# Initialize array to store all items
$allItems = @()

# Process each JSON file
foreach ($file in $jsonFiles) {
    try {
        # Read and parse the JSON file
        $itemData = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json
        
        # Create a simplified object with only the required fields
        $simplifiedItem = [PSCustomObject]@{
            id = $itemData.id
            name = $itemData.name
            type = $itemData.type
            rarity = $itemData.rarity
            image_location = $itemData.image_location
        }
        
        # Add to the array
        $allItems += $simplifiedItem
        
        Write-Host "Processed: $($file.Name)"
    }
    catch {
        Write-Warning "Failed to process $($file.Name): $_"
    }
}

# Convert to JSON and save
$jsonOutput = $allItems | ConvertTo-Json -Depth 10

# Write to file
Set-Content -Path $outputFile -Value $jsonOutput -Encoding UTF8

Write-Host "`nSuccessfully generated $outputFile"
Write-Host "Total items processed: $($allItems.Count)"
