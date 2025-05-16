$setupPath = "E:\setup.exe"
$configFile = "C:\SQL2022\SQLFCI.ini"

Start-Process -FilePath $setupPath -ArgumentList "/ConfigurationFile=$configFile" -Wait -NoNewWindow
