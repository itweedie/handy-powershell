param(
    [string]$locationOfUnpackedSolution,
    [string]$wikiLocation
)

# Validation: Check if locationOfUnpackedSolution and wikiLocation have been provided
if (-not $locationOfUnpackedSolution -or -not $wikiLocation) {
    Write-Output "Both locationOfUnpackedSolution and wikiLocation parameters are required."
    Write-Output "Usage: .\script.ps1 -locationOfUnpackedSolution 'C:\Dev\ClaimsHandling\ClaimsHandling\scr\solutions\ClaimsHandlingCore' -wikiLocation 'C:\Dev\hmwmt\blog\notes\CHS\test\11'"
    exit
}

# Construct the path to the entities folder
$entitiesFolder = Join-Path -Path $locationOfUnpackedSolution -ChildPath "entities"

Write-Output "Solution folder set to: $locationOfUnpackedSolution"
Write-Output "Entities folder set to: $entitiesFolder"
Write-Output "Wiki location for Markdown files set to: $wikiLocation"

# Check if the wiki location exists; if not, create it
if (-not (Test-Path -Path $wikiLocation)) {
    New-Item -ItemType Directory -Path $wikiLocation
    Write-Output "Created wiki location at: $wikiLocation"
}

# Get all subdirectories in the entities folder
$entityFolders = Get-ChildItem -Path $entitiesFolder -Directory

foreach ($folder in $entityFolders) {
    Write-Output "Processing folder: $($folder.FullName)"
    $entityFile = Join-Path -Path $folder.FullName -ChildPath "Entity.xml"
    # Check if Entity.xml exists in the folder
    if (Test-Path $entityFile) {
        Write-Output "Found Entity.xml in $($folder.FullName)"
        [xml]$xmlContent = Get-Content -Path $entityFile

        # Extracting the entity name to use as the Markdown file name
        $entityName = $xmlContent.Entity.Name.'#text'
        if (-not $entityName) {
            $entityName = $xmlContent.Entity.Name.OriginalName
        }

        # Initialize Markdown content with entity details
        $markdownContent = "# Entity: $entityName`n"
        $markdownContent += "## Localized Name: $($xmlContent.Entity.Name.LocalizedName)`n`n"

        # Start Attributes table
        $markdownContent += "## Attributes`n"
        $markdownContent += "| Name | Type | Display Name | Required Level | Is Custom Field | Is Searchable |`n"
        $markdownContent += "|------|------|--------------|----------------|-----------------|---------------|`n"

        # Fill the table with attribute details
        foreach ($attribute in $xmlContent.Entity.EntityInfo.entity.attributes.attribute) {
            $displayName = $attribute.displaynames.displayname.description
            $markdownContent += "| $($attribute.Name) | $($attribute.Type) | $displayName | $($attribute.RequiredLevel) | $($attribute.IsCustomField) | $($attribute.IsSearchable) |`n"
        }

        # Define the output Markdown file name using the entity name and saving it to the wiki location
        $mdFileName = Join-Path -Path $wikiLocation -ChildPath "$entityName.md"
        # Save the Markdown content to a file
        $markdownContent | Out-File -FilePath $mdFileName -Encoding UTF8
        Write-Output "Markdown documentation generated for entity '$entityName' at: $mdFileName"
    } else {
        Write-Output "No Entity.xml found in $($folder.FullName)"
    }
}
Write-Output "Processing complete."
