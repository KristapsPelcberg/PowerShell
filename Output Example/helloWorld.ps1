#Create output in terminal
cls                                                                                 #Clean terminal output
Write-Host -ForegroundColor Red "Hello World!"                                      #Create ouptu in terminal in red color

#hello Word GUI
Set-ExecutionPolicy RemoteSigned                                                    #Set execution policy to access resources outside local machine
Install-Module -Name AnyBox                                                         #Install AnyBox module on your local machine
Import-Module -Name Anybox                                                          #Import AnyBox module in your script
$anybox=New-Object AnyBox.AnyBox                                                    #Create AnyBox object
$anybox.ContentAlignment='Center'                                                   #Set Alligment to all objects inside AnyBox Object
$anybox.Buttons += New-AnyBoxButton -Name 'Cancel' -IsCancel -Text 'Cancel'         #Added Cancel Button to AnyBox object
$anybox.Title = 'Hello World Title!'                                                #Added Title text to AnyBox object
$anybox.Icon = 'Question'                                                           #Added question icon to AnyBox object
$anybox.Comment += "Hello World"                                                    #Added main text to AnyBox object
$anybox | Show-AnyBox                                                               #Display AnyBox object to screen

#Hello Word File txt

$folderPath="$env:PUBLIC\Desktop\TestFolder"                                       #Define local path

If(!(test-path $folderPath))                                                       #Check if path doesn't exist
{
#local path doesn't exist
      New-Item -ItemType Directory -Force -Path $folderPath                        #Create folder
}else{
#local path exist
      Remove-Item -Path $folderPath                                                #Delete existing folder
      New-Item -ItemType Directory -Force -Path $folderPath                        #Create folder
}
$txtOutput="Hello World"                                                           #Declear String variable with output text
$txtOutput | Out-File -FilePath $folderPath\HelloWorld.txt -Append                 #Create output file in declared local path and append text variable to that file
