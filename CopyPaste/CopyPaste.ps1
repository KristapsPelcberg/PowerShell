$path1="$env:PUBLIC\Desktop\TestFolderCopy"               #Define local path
$path2="$env:PUBLIC\Desktop\TestFolderPaste"              #Define local path


If(!(test-path $path1))                                   #Check if path1 doesn't exist
{
#local path doesn't exist
      New-Item -ItemType Directory -Force -Path $path1    #Create folder
      Out-File -FilePath $path1\copy.txt                  #Create text files
      Out-File -FilePath $path1\cut.txt                   #Create text files
      Out-File -FilePath $path1\delete.txt                #Create text files
}else{
#local path exist
        Remove-Item -Path $path1                            #Delete folder
        New-Item -ItemType Directory -Force -Path $path1    #Create folder
        Out-File -FilePath $path1\copy.txt                  #Create text files
        Out-File -FilePath $path1\cut.txt                   #Create text files
        Out-File -FilePath $path1\delete.txt                #Create text files
}

If(!(test-path $path2))                                    #Check if path2 doesn't exist
{
      New-Item -ItemType Directory -Force -Path $path2     #Create folder
}else{
    Remove-Item -Path $path2                               #Delete existing folder
    New-Item -ItemType Directory -Force -Path $path2       #Create folder
}
Start-Sleep -s 5                                           #Stop script for 5 seconds
Copy-Item -Path $path1\copy.txt -Destination $path2        #Copy "copy.txt" file to path 2
Start-Sleep -s 5                                           #Stop script for 5 seconds
Move-Item -Path $path1\cut.txt -Destination $path2         #Cut "cut.txt" file to path 2
Start-Sleep -s 5                                           #Stop script for 5 seconds
Remove-Item -Path $path1\delete.txt                        #Delete "delete.txt" file
