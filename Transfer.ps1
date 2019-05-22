<#

Create additional accounts for employee transfers

.AUTHOR
Frank Castle

.SYNOPSIS
Create a clone of an existing AD user account, Exchange, Skype for Business

.DESCRIPTION 
This PowerShell script will prompt for a user to clone and create an additional account with a 1 on the end. 
User will be created in OU=Transfers,DC=gradientfg,DC=COM 
Create mailbox in GPS_1
Create SFB user on prem.

#>



$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Please enter your super hero credentials.  It should be in the form of DOMAIN\username.",0,"Credentials Required!",0x0)
$credentials = Get-Credential
$PSDefaultParameterValues = @{"*-AD*:Credential"=$credentials}

#Import Active Directory Module
Import-Module ActiveDirectory


$samaccountname = Read-Host "Type samaccountname that we will clone"
Write-Host "THIS WINDOW WILL CLOSE ON ITS OWN WHEN THE SCRIPT IS DONE" -ForegroundColor Yellow -BackgroundColor Magenta
$name = Get-ADUser -Identity $samaccountname | Select-Object -ExpandProperty Name
$firstname = Get-ADUser -Identity $samaccountname | Select-Object -ExpandProperty GivenName
$lastname = Get-ADUser -Identity $samaccountname | Select-Object -ExpandProperty Surname
$state = Get-ADUser -Identity $samaccountname -Properties * | Select-Object -ExpandProperty State 

New-ADUser -Name $name `
-SamAccountName $($samaccountname+1) `
-UserPrincipalName "$($samaccountname+1)@gradientfg.com" `
-DisplayName $name `
-GivenName $firstname `
-Surname $lastname `
-State $State `
-AccountPassword (ConvertTo-SecureString "Resetme123!" -AsPlainText -Force) `
-Enabled $True `
-Path "OU=Transfers,DC=gradientfg,DC=COM"

if ($state -eq 'MN') 
    {Set-ADUser -Identity $($samaccountname+1) -StreetAddress '4105 Lexington Avenue North' `
    -PostalCode '55126' -City 'Arden Hills'}
    Else {Set-ADUser -Identity $($samaccountname+1) -StreetAddress '3740 SW Burlingame Circle' `
    -PostalCode '66609' -City 'Topeka'}

#Connecting to Exchange and create account
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://gfgm1exch01.gradientfg.com/PowerShell/ -Credential $credentials

Import-PSSession $session -DisableNameChecking -AllowClobber

Enable-Mailbox -Identity $($samaccountname+1) -Database "GPS_1" -Alias $($samaccountname+1)


#Connect to Skype for Business and create account
$sfbsession = New-PSSession -ConnectionUri "https://gfgm1sfb01.gradientfg.com/OcsPowershell" -Credential $credentials
Import-PSSession $sfbsession -DisableNameChecking -AllowClobber

Enable-CsUser -Identity $($samaccountname+1) `
    -RegistrarPool "gfgm1sfb01.gradientfg.com" `
    -SipAddressType SamAccountName -SipDomain gradientfg.com `

