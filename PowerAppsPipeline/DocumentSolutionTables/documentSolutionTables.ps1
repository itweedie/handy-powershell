param(
    [string]$rootFolder,
    [string]$targetFolder
)


# Validation: Check if locationOfUnpackedSolution and wikiLocation have been provided
if (-not $locationOfUnpackedSolution -or -not $wikiLocation) {
    Write-Output "Both locationOfUnpackedSolution and wikiLocation parameters are required."
    Write-Output "Usage: .\script.ps1 -locationOfUnpackedSolution '<path_to_unpacked_solution>' -wikiLocation '<path_to_wiki_location>'"
    exit
}

Write-Output "Root folder set to: $rootFolder"
Write-Output "Target folder for Markdown files set to: $targetFolder"

# Check if the target folder exists; if not, create it
if (-not (Test-Path -Path $targetFolder)) {
    New-Item -ItemType Directory -Path $targetFolder
    Write-Output "Created target folder at: $targetFolder"
}

# Get all subdirectories in the root folder
$entityFolders = Get-ChildItem -Path $rootFolder -Directory

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

        # Define the output Markdown file name using the entity name and saving it to the target folder
        $mdFileName = Join-Path -Path $targetFolder -ChildPath "$entityName.md"
        # Save the Markdown content to a file
        $markdownContent | Out-File -FilePath $mdFileName -Encoding UTF8
        Write-Output "Markdown documentation generated for entity '$entityName' at: $mdFileName"
    } else {
        Write-Output "No Entity.xml found in $($folder.FullName)"
    }
}
Write-Output "Processing complete."
