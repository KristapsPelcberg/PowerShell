cls                                                                                                                     #Clean terminal output
$folderPath="$env:PUBLIC\Desktop\TestFolderDownload"                                                                    #Define local path

If(!(test-path $folderPath))                                                                                            #Check if path doesn't exist
{
      New-Item -ItemType Directory -Force -Path $folderPath                                                             #Create folder
}

$filePath="$folderPath\npp.7.9.5.Installer.x64.exe"                                                                    #Define installer full path (Bad Example)  
$url = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.9.5/npp.7.9.5.Installer.x64.exe"   #Define installer url
Invoke-WebRequest -Uri $url -OutFile $filePath                                                                         #Invoke Webrequest to trigger download to our pre definde path

Start-Process $filePath -ArgumentList '/S' -Verb runas -Wait                                                           #Start silance installation without any configuartion changes 

$software = "Notepad++ (64-bit x64)";                                                                                  #Hard code software name
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |                           #Create boolean variable that check if software with defined name is installed
Where { $_.DisplayName -Contains $software }) -ne $null

Set-ExecutionPolicy RemoteSigned                                                                                       #Set execution policy to access resources outside local machine
Install-Module -Name AnyBox                                                                                            #Install AnyBox module on your local machine
Import-Module -Name Anybox                                                                                             #Import AnyBox module in your script
$anybox=New-Object AnyBox.AnyBox                                                                                       #Create AnyBox object
$anybox.ContentAlignment='Center'                                                                                      #Set Alligment to all objects inside AnyBox Object
$anybox.Buttons += New-AnyBoxButton -Name 'Cancel' -IsCancel -Text 'Cancel'                                            #Added Cancel Button to AnyBox object
$anybox.Title = 'Program Status'                                                                                       #Added Title text to AnyBox object

If(-Not $installed) {                                                                                                  #Check if software with defined name is not installed
    $anybox.Comment += "'$software' NOT is installed."                                                                 #Added text that software with that name is not installed to AnyBox object
} else {
    $anybox.Comment += "'$software' is installed"                                                                      #Added text that software with that name is installed to AnyBox object
    $anybox.Buttons += New-AnyBoxButton -Name 'Info' -Text 'Info'                                                      #Added Info Button to AnyBox object
    $anybox.Buttons += New-AnyBoxButton -Name 'Uninstall' -Text 'Uninstall'                                            #Added Uninstall Button to AnyBox object

}
$mainBox=$anybox | Show-AnyBox                                                                                         #Display AnyBox object to screen

if($mainBox['Info']){                                                                                                  #Check if users is clicked Info button   
                                                                                                                       #Find exact name of software by searching software name in global uninstall path                                                                                          
    $name=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
    | Where { $_.DisplayName -Contains "Notepad++ (64-bit x64)" } `
    | Select-Object -ExpandProperty DisplayName | Out-String
                                                                                                                       #Find company name of software by searching software name in global uninstall path
    $team=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
    | Where { $_.DisplayName -Contains "Notepad++ (64-bit x64)" } `
    | Select-Object -ExpandProperty Publisher | Out-String
                                                                                                                       #Find size of software by searching software name in global uninstall path
    $size=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
    | Where { $_.DisplayName -Contains "Notepad++ (64-bit x64)" } `
    | Select-Object -ExpandProperty EstimatedSize | Out-String
                                                                                                                       #Find exact verion of software by searching software name in global uninstall path
    $version=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
    | Where { $_.DisplayName -Contains "Notepad++ (64-bit x64)" } `
    | Select-Object -ExpandProperty DisplayVersion | Out-String
                                                                                                                       #Find exact path of software by searching software name in global uninstall path
    $path=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
    | Where { $_.DisplayName -Contains "Notepad++ (64-bit x64)" } `
    | Select-Object -ExpandProperty DisplayIcon
    
    $anyboxInfo=New-Object AnyBox.AnyBox                                                                              #Create AnyBox object                                                                        
    $anyboxInfo.ContentAlignment='Center'                                                                             #Set Alligment to all objects inside AnyBox Object
    $anyboxInfo.Buttons += New-AnyBoxButton -Name 'Cancel' -IsCancel -Text 'Cancel'                                   #Added Cancel Button to AnyBox object
    $anyboxInfo.Title = 'Program Info'                                                                                #Added Title text to AnyBox object
    $anyboxInfo.Comment += "Name:"+$name                                                                              #Added Name text to AnyBox object
    $anyboxInfo.Comment += "Publisher:"+$team                                                                         #Added Company text to AnyBox object
    $anyboxInfo.Comment += "Size:"+$size                                                                              #Added size text to AnyBox object
    $anyboxInfo.Comment += "Version:"+$version                                                                        #Added version text to AnyBox object
    $anyboxInfo.Comment += "Path: "+$path.Replace("`n","")                                                            #Added path text to AnyBox object
    $anyboxInfo.Buttons += New-AnyBoxButton -Name 'Open' -Text 'Open Notepad++'                                       #Added "Open" button to AnyBox object

    $infoBox=$anyboxInfo | Show-AnyBox                                                                                #Display AnyBox object to screen
        if($infoBox['Open']){                                                                                         #Check if users is clicked Open button
            Invoke-Item -Path $path                                                                                   #Start Notepad++ exe file
        }
}

if($mainBox['Uninstall']){                                                                                            #Check if users is clicked Uninstall button
                                                                                                                      #Get uninstall path of programm
$unistallPath=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
| Where { $_.DisplayName -Contains "Notepad++ (64-bit x64)" } `
| Select-Object -ExpandProperty UninstallString
Start-Process $unistallPath -ArgumentList '/S' -Verb runas -Wait                                                     #Start silent uninstall process
Break                                                                                                                #Stop script
}
