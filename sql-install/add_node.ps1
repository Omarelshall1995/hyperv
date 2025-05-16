$setupPath = "E:\setup.exe"
$configFile = "C:\SQL2022\SQLAddNode.ini"

Start-Process -FilePath $setupPath -ArgumentList "/ConfigurationFile=$configFile" -Wait -NoNewWindow
