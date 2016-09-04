<# The name of this .ps1 file must match the name of the Configuration in order for Import-AzureRmAutomationDscConfiguration to work #>
Configuration SonarQubeDeploy
{ 
    param(
        [string] $InstallPath = "c:\SonarQube",
        [string] $SonarQubeVersion = "5.6"
    )
    $ArchiveFileName = "sonarqube-$($SonarQubeVersion).zip"

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName cChoco 
    Import-DscResource -Name MSFT_xRemoteFile -ModuleName xPSDesiredStateConfiguration

   Node "Deploy" {   

        cChocoInstaller installChoco
        { 
            InstallDir = "C:\ProgramData\chocolatey" 
        }

        cChocoPackageInstaller installJava 
        { 
            DependsOn = "[cChocoInstaller]installChoco" 
            Name = "jre8" 
        } 

        File SonarQubeDirectory
        {
            Ensure = "Present"
            DestinationPath = "$InstallPath"
            Type = "Directory"            
        }        
      
        xRemoteFile DownloadSonarQube
        {
            DependsOn = "[File]SonarQubeDirectory" 
            Uri = "https://sonarsource.bintray.com/Distribution/sonarqube/$ArchiveFileName"
            DestinationPath = "$InstallPath\$ArchiveFileName"
        }

        Archive UnzipSonarQube 
        {
            DependsOn = "[xRemoteFile]DownloadSonarQube"
            Path = "$InstallPath\$ArchiveFileName"            
            Destination = "$InstallPath"
        } 

        Environment SonarQubeHome
        {
            Ensure = "Present"
            Name = "SONARQUBE_HOME"
            Value = "$($InstallPath)\sonarqube-$($SonarQubeVersion)"
        }

    }
}
