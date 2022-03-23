Start-Process 'C:\windows\system32\notepad.exe'     #Start process from direct path
Start-Sleep -s 5                                    #Stop script for 5 seconds
Stop-Process -Name "notepad"                        #Close process
