<#
Author: Adam Eaddy
Company: ITS Partners
Date: 12/01/2020
Email: aeaddy@itsdelivers.com
Purpose: 
/#>

#The directory that the logs will be written to. (Please be sure to choose a directory with permissions to write to.)
$LOGDIR = "$env:TEMP\SCCM ServiceNow Review"
#SCCM Limiting Collection
$LIMITINGCOLL = "All Systems"

#Configure Logging
$FORMATTEDDATE = Get-Date -format "MM-dd-yy"
$UFORMATTEDDATE = get-date
$LOGFILE = "CfgMgr_SN_Review_" + $FORMATTEDDATE + ".log"
$LOGPATH = "$LOGDIR\$LOGFILE"
$LOGTEST = Test-Path $LOGPATH
If ($LOGTEST -eq $false) {
    New-Item -Path $LOGDIR -Name $LOGFILE -Force
}

Write-Output "********Begin Logging $UFORMATTEDDATE********" | out-file $LOGPATH -Append -Force -NoClobber 

#Clear logs older than 6 days
Get-ChildItem $LOGDIR -Recurse -File | Where CreationTime -lt  (Get-Date).AddDays(-6)  | Remove-Item -Force

#Import the ConfigMgr PowerShell module & connect to ConfigMgr PSDrive
$snip = $env:SMS_ADMIN_UI_PATH.Length-5
$modPath = $env:SMS_ADMIN_UI_PATH.Substring(0,$snip)
Import-Module "$modPath\ConfigurationManager.psd1"
$SiteCode = Get-PSDrive -PSProvider CMSite
Set-Location "$($SiteCode.Name):\"
$PSD = $($SiteCode.Name)



Function GetInstallString{
Param ($AppName)
$CMADT = Get-CMDeploymentType -ApplicationName $AppName
    foreach ($CMADTI in $CMADT) {
        $CD = $CMADTI.SDMPackageXML
        $doc = [xml]$CD
        $doc.AppMgmtDigest.DeploymentType.Installer.InstallAction.Args.Arg[0].'#text'
    }
}

Function GetUninstallString{
Param ($AppName)
$CMADT = Get-CMDeploymentType -ApplicationName $AppName
    foreach ($CMADTI in $CMADT) {
        $CD = $CMADTI.SDMPackageXML
        $doc = [xml]$CD
        $doc.AppMgmtDigest.DeploymentType.Installer.UninstallAction.Args.Arg[0].'#text'
    }
}



$CMPkgs = Get-CMPackage -Fast
$CMPkgCount = $CMPkgs.count

$CMApps = Get-CMApplication
$CMAppCount = $CMApps.count

$CMDevColls = Get-CMDeviceCollection
$CMDevCollCount = $CMDevColls.count

$CMUserColls = Get-CMUserCollection
$CMUserCollCount = $CMUserColls.count

$CMPkgDeps = Get-CMPackageDeployment
$CMPkgDepsCount = $CMPkgDeps.count

$CMAppDeps = Get-CMApplicationDeployment
$CMAppDepsCount = $CMAppDeps.count

