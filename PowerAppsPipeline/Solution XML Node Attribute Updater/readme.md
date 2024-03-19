# PowerShell Solution for XML Node Attribute Updater

This PowerShell script provides the functionality to update the value of a specified attribute for a node in an XML file. By specifying the XML file path, the node's XPath, the attribute name, and the new value, users can easily modify XML node attributes directly from the command line.

## Prerequisites

- PowerShell 5.1 or higher (Script is developed and tested on this version)
- Basic understanding of XML file structures and XPath syntax

Before running the script, you may need to adjust your PowerShell execution policy to allow scripts to run. PowerShell may restrict script execution by default. To change the execution policy for your user account to `Unrestricted`, which permits all PowerShell scripts to run, execute the following command in PowerShell:

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

## Installation

No installation is required. Ensure PowerShell is installed on your system. Download the script or copy it into a new `.ps1` file on your local machine.

### Creating the Script File

1. Open a text editor (e.g., Notepad, Visual Studio Code).
2. Copy the updated PowerShell script.
3. Save the file with a `.ps1` extension, for example, `UpdateXmlNodeAttribute.ps1`.

## Usage

To use the script, open PowerShell and navigate to the directory where your script is located. Then, run the script with the required parameters:

```powershell
.\updateXMLNodeAttributeUpdater.ps1 -xmlFilePath "C:\path\to\your\file.xml" -nodeXPath "/AppModule/LocalizedNames/LocalizedName" -attributeName "YourAttributeName" -newValue "YourNewValue"
```
Replace `C:\path\to\your\file.xml` with the path to your XML file, `/YourNodeXPath` with the XPath to your target node, `YourAttributeName` with the name of the attribute you wish to update, and `YourNewValue` with the value you wish to assign to the attribute.

## Parameters

- `xmlFilePath`: The full path to your XML file.
- `nodeXPath`: The XPath expression to locate the node you want to update.
- `attributeName`: The name of the attribute whose value you want to update.
- `newValue`: The new value you wish to assign to the attribute.

## License
Distributed under the MIT License. See LICENSE for more information
