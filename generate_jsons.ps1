$pngs = Get-ChildItem -Recurse -Filter *.png
$root = Get-Location
$itemsDir = Join-Path $root "Data\items"
foreach ($png in $pngs) {
    $filename = $png.BaseName
    $id = $filename
    $name = (Get-Culture).TextInfo.ToTitleCase( ($filename -replace '_', ' ') )
    $imageLocation = "https://raw.githubusercontent.com/ArcInformer/ArcInformer_Assets/refs/heads/main/Game%20Assets/Items/$filename.png"
    $inGameImageLocation = "https://raw.githubusercontent.com/ArcInformer/ArcInformer_Assets/refs/heads/main/Game%20Assets/Items_Ingame/$filename.png"
    $json = @"
{
    "id": "$id",
    "name": "$name",
    "description": "",
    "type": "",
    "rarity": "",
    "value": 0,
    "weight": 0,
    "stack_size": 0,
    "recycles_into": {
    },
    "image_location": "$imageLocation",
    "in_game_image_location": "$inGameImageLocation",
    "last_updated": ""
}
"@
    $jsonPath = Join-Path $itemsDir "$filename.json"
    New-Item -ItemType File -Path $jsonPath -Force | Out-Null
    Set-Content -Path $jsonPath -Value $json
}