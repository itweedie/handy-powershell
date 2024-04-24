<#
.SYNOPSIS
This script creates an Azure AD application registration and service principal for Dataverse with necessary permissions and a client secret.

.DESCRIPTION
This script uses the Microsoft.Graph PowerShell module to connect to Microsoft Graph, create an application registration, assign the necessary permissions, create a service principal, and manage a client secret. It can optionally keep the connection open.

.PARAMETER AppName
The display name for the Azure AD application registration.

.PARAMETER StayConnected
A switch to determine if the script should stay connected to Microsoft Graph after completion.

.EXAMPLE
.\CreateAppRegistration.ps1 -AppName "MyApp" -StayConnected
Creates an app registration and stays connected after script completion.
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="Enter the display name for the app registration")]
    [string]$AppName,

    [Parameter(Mandatory=$false)]
    [switch]$StayConnected = $false
)

# Install and import the Microsoft.Graph module if not available
$moduleName = "Microsoft.Graph"
if (-not (Get-Module -ListAvailable -Name $moduleName)) {
    Install-Module -Name $moduleName -Scope CurrentUser -Force -Confirm:$false
}

# Update the module just in case it's already installed but not updated
Update-Module -Name $moduleName -Confirm:$false

# Import module
Import-Module -Name $moduleName -ErrorAction Stop

# Requires an admin connection to Microsoft Graph with specific permissions
Connect-MgGraph -Scopes "Application.ReadWrite.All AppRoleAssignment.ReadWrite.All User.Read" -UseDeviceAuthentication -ErrorAction Stop

# Retrieve context for access to tenant ID
$context = Get-MgContext -ErrorAction Stop
$authTenant = $context.TenantId

# Create app registration
$appRegistration = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -ErrorAction Stop
Write-Host "App registration created with app ID: $($appRegistration.AppId)" -ForegroundColor Cyan

# Create corresponding service principal
$appServicePrincipal = New-MgServicePrincipal -AppId $appRegistration.AppId -ErrorAction SilentlyContinue -ErrorVariable SPError
if ($SPError) {
    Write-Host "A service principal for the app could not be created." -ForegroundColor Red
    Write-Host $SPError -ForegroundColor Red
    Exit
}
Write-Host "Service principal created" -ForegroundColor Cyan

# Define the required permissions for Dataverse
$dataverseAppId = "00000007-0000-0000-c000-000000000000"
$resourceAccess = @{
    Id = "78ce3f0f-a1ce-49c2-8cde-64b5c0896db4"
    Type = "Scope"
}

# Add the permissions to the application registration
$updateParams = @{
    ApplicationId = $appRegistration.Id
    RequiredResourceAccess = @{
        ResourceAppId = $dataverseAppId
        ResourceAccess = @($resourceAccess)
    }
    ErrorAction = 'Stop'
}
Update-MgApplication @updateParams
Write-Host "Added application permissions to app registration" -ForegroundColor Cyan

# Add a client secret
$clientSecret = Add-MgApplicationPassword -ApplicationId $appRegistration.Id -PasswordCredential @{
    DisplayName = "Added by PowerShell"
} -ErrorAction Stop

# Display creation success message
Write-Host "SUCCESS" -ForegroundColor Green
Write-Host "Client ID: $($appRegistration.AppId)" -ForegroundColor Yellow
Write-Host "Tenant ID: $authTenant" -ForegroundColor Yellow
Write-Host "Client secret: $($clientSecret.SecretText)" -ForegroundColor Yellow
Write-Host "Secret expires: $($clientSecret.EndDateTime)" -ForegroundColor Yellow

# Manage connection state after script execution
if (-not $StayConnected) {
    Disconnect-MgGraph | Out-Null
    Write-Host "Disconnected from Microsoft Graph"
} else {
    Write-Host "The connection to Microsoft Graph is still active. To disconnect, use Disconnect-MgGraph" -ForegroundColor Yellow
}
