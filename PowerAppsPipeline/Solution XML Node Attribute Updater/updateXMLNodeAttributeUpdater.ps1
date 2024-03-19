param (
    [string]$xmlFilePath,
    [string]$nodeXPath,
    [string]$attributeName,
    [string]$newValue
)

function Update-XmlNode {
    param (
        [string]$XmlFilePath,
        [string]$NodeXPath,
        [string]$AttributeName,
        [string]$NewValue
    )

    # Load the XML file
    Write-Host "Loading XML file: $XmlFilePath"
    $xml = New-Object System.Xml.XmlDocument
    $xml.Load($XmlFilePath)

    # Select the node
    Write-Host "Selecting node with XPath: $NodeXPath"
    $node = $xml.SelectSingleNode($NodeXPath)

    if ($node -ne $null) {
        # Update the attribute value
        Write-Host "Updating attribute '$AttributeName' to: $NewValue"
        $node.SetAttribute($AttributeName, $NewValue)

        # Save the XML file
        Write-Host "Saving changes to XML file"
        $xml.Save($XmlFilePath)
        
        Write-Host "Update completed successfully."
    }
    else {
        Write-Host "Node not found."
    }
}

# Call the function with the parameters
Update-XmlNode -XmlFilePath $xmlFilePath -NodeXPath $nodeXPath -AttributeName $attributeName -NewValue $newValue
