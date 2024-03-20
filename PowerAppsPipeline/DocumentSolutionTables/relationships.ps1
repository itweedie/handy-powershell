param (
    [string]$locationOfUnpackedSolution,
    [string]$wikiLocation
)

# Ensure the target directory exists, create it if it does not
if (-Not (Test-Path -Path $wikiLocation)) {
    New-Item -ItemType Directory -Path $wikiLocation | Out-Null
}

# Construct the path to the Other/Relationships subfolder
$relationshipsDirectory = Join-Path -Path $locationOfUnpackedSolution -ChildPath "Other\Relationships"

# Verify the Relationships directory exists
if (-Not (Test-Path -Path $relationshipsDirectory)) {
    Write-Error "The specified path to the Other/Relationships directory does not exist: $relationshipsDirectory"
    exit
}

# Get all XML files in the Relationships directory
$xmlFiles = Get-ChildItem -Path $relationshipsDirectory -Filter "*.xml"

foreach ($xmlFile in $xmlFiles) {
    [xml]$xmlContent = Get-Content $xmlFile.FullName

    # Use the full name of the XML file, including its extension, for the entity name
    $entityName = $xmlFile.BaseName

    # Start building the Markdown content
    $mdContent = @("# $($entityName) Table Relationships")

    # Add Mermaid diagram start
    $mdContent += [uri]::UnescapeDataString("%60%60%60mermaid")
    $mdContent += "graph LR"

    # Add table header
    $tableContent = @()
    $tableContent += "| Name | Type | Referencing Entity | Referenced Entity | Cascades |"
    $tableContent += "| ---- | ---- | ------------------ | ----------------- | -------- |"

    foreach ($entityRelationship in $xmlContent.EntityRelationships.EntityRelationship) {
        # For Mermaid diagram
        $referencingEntityName = $entityRelationship.ReferencingEntityName
        $referencedEntityName = $entityRelationship.ReferencedEntityName
        $referencingAttributeName = $entityRelationship.ReferencingAttributeName
        $relationshipType = switch ($entityRelationship.EntityRelationshipType) {
            "OneToMany" { "-->" }
            "ManyToOne" { "<--" }
            "ManyToMany" { "---" }
            Default { "--" }
        }
        $mdContent += "$referencingEntityName $relationshipType |$referencingAttributeName| $referencedEntityName"

        # For table
        $tableLine = "| $($entityRelationship.Name) | $($entityRelationship.EntityRelationshipType) | $($entityRelationship.ReferencingEntityName) | $($entityRelationship.ReferencedEntityName) | Assign: $($entityRelationship.CascadeAssign), Delete: $($entityRelationship.CascadeDelete) |"
        $tableContent += $tableLine
    }

    # Close Mermaid diagram
    $mdContent += [uri]::UnescapeDataString("%60%60%60")

    # Add table content to the Markdown content
    $mdContent += $tableContent -join "`n"

    # Determine the output file name based on the XML file name
    $mdFileName = "$($xmlFile.BaseName)-relationships.md"
    $mdFilePath = Join-Path -Path $wikiLocation -ChildPath $mdFileName

    # Write the content to the MD file
    $mdContent | Out-File -FilePath $mdFilePath
}

Write-Host "Processed $($xmlFiles.Count) files."
