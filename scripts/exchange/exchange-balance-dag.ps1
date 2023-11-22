# Param

    Param
    (
      [Parameter(Mandatory)]
      [string]$Username,

      [Parameter(Mandatory)]
      [string]$Password,

      [Parameter(Mandatory)]
      [string]$DAG
    )

# Initalise Variables

    $SystemHostname = (hostname).ToString()
    $ErrorActionPreference = 'Stop'
    $MailboxDatabaseCopyStatus = @()
    $ServiceHealth = @()
    
# Create Credential Object

    [securestring]$secStringPassword = ConvertTo-SecureString $Password -AsPlainText -Force
    [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($Username, $secStringPassword)

# Import Required Powershell Modules and SnapIns

    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$($SystemHostname)/PowerShell/ -Authentication Kerberos -Credential $credObject
    $CreateSession = Import-PSSession $Session -DisableNameChecking
    #Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

# Balance Databases in Availability Group

    & 'C:\Program Files\Microsoft\Exchange Server\V15\Scripts\RedistributeActiveDatabases.ps1' -DagName $($DAG) -BalanceDbsByActivationPreference -confirm:$false

# Cleanup Session

    Remove-PSSession $Session