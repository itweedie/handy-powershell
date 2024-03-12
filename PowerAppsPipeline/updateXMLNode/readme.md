# PowerShell XML Node Updater

This PowerShell script allows users to update the value of a specified node in an XML file. By supplying the location of the XML file, the node address (XPath), and the new value, users can easily modify XML nodes directly from the command line.

## Prerequisites

- PowerShell 5.1 or higher (Script is developed and tested on this version)
- Basic understanding of XML file structures and XPath syntax

Before running the script, you may need to adjust your PowerShell execution policy to allow the script to run. By default, PowerShell might restrict the execution of scripts. To change the execution policy for your user account to `Unrestricted` (which allows all PowerShell scripts to run), execute the following command in PowerShell:

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

## Installation

No installation is required. Just ensure you have PowerShell installed on your system. You can download the script or copy it into a new `.ps1` file on your local machine. 

### Creating the Script File

1. Open a text editor (e.g., Notepad, Visual Studio Code).
2. Copy the PowerShell script provided earlier.
3. Save the file with a `.ps1` extension, for example, `UpdateXmlNode.ps1`.

## Usage

To use the script, open PowerShell and navigate to the directory where your script is located. Then run the script with the required parameters:

```powershell
.\UpdateXmlNode.ps1 -xmlFilePath "C:\path\to\your\file.xml" -nodeXPath "/AppModule/LocalizedNames/LocalizedName" -newValue "YourNewValue"
```

Replace C:\path\to\your\file.xml with the path to your XML file, //YourNodeXPath with the XPath to your target node, and YourNewValue with the value you wish to set.

## Parameters
- xmlFilePath: The full path to your XML file.
- nodeXPath: The XPath expression to locate the node you want to update.
- newValue: The new value you wish to assign to the node.

## License
Distributed under the MIT License. See LICENSE for more information
