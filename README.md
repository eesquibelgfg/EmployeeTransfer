# EmployeeTransfer
Script to create additional accounts when an employee transfers to a new company

<#
Create additional accounts for employee transfers

.SYNOPSIS
Create a clone of an existing AD user account, Exchange, Skype for Business

.DESCRIPTION 
This PowerShell script will prompt for a user to clone and create an additional account with a 1 on the end. 
User will be created in OU=Transfers,DC=gradientfg,DC=COM 
Create mailbox in GPS_1
Create SFB user on prem.

.NOTES
Look at Adding o365 Group based on Company. Sync AD with Azure AD. Migrate user out to o365
Created by Eric Esquibel

#>

