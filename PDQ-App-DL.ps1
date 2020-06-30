<#
    Download installers for TAFEITLAB using Invoke-WebRequest
    Last updated: 2020-06-29
#>

# Set variable for PDQ Repo (Download target location)
Set-Variable -Name PDQRepo -Value "C:\Users\Public\Documents\Admin Arsenal\PDQ Deploy\Repository"

<#
    App download list
    Add current version number and uncomment as needed.
    Re-comment after download complete.

    Template:
    Invoke-WebRequest -Uri FOO -OutFile "BAH"

    NB: ## = Version number

#>
#7zip
#Invoke-WebRequest -Uri https://www.7-zip.org/a/7z####-x64.exe -OutFile "$PDQRepo\7zip\7z####-x64.exe"

#Adobe Acrobat Reader DC
#Invoke-WebRequest -Uri ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/##########/ -OutFile "$PDQRepo\Adobe Acrobat Reader DC\AcroRdrDCUpd##########.msp"

#Cisco Packet Tracer
## May need to be manually downloaded due to need for account authentication
#Invoke-WebRequest -Uri FOO -OutFile "BAH"

#Dropbox
#Invoke-WebRequest -Uri https://clientupdates.dropboxstatic.com/dbx-releng/client/Dropbox%20###.#.##.%20Offline%20Installer.exe -OutFile "$PDQRepo\Dropbox\Dropbox.###.#.###.exe"

#Filezilla
#Invoke-WebRequest -Uri FOO -OutFile "BAH"

#GNS3
## Main installer
#Invoke-WebRequest -Uri https://downloads.solarwinds.com/solarwinds/GNS3/v#.#.##/GNS3-#.#.##-all-in-one-regular.exe -OutFile "$PDQRepo\GNS3\GNS3-#.#.##-all-in-one-regular.exe"
## Virtual Machine (VMware Workstation)
#Invoke-WebRequest -Uri https://github.com/GNS3/gns3-gui/releases/download/v#.#.##/GNS3.VM.VMware.Workstation.#.#.##.zip -OutFile "$PDQRepo\GNS3\GNS3.VM.VMware.Workstation.#.#.##.zip"
## Virtual Machine (VMware ESXi)
#Invoke-WebRequest -Uri https://github.com/GNS3/gns3-gui/releases/download/v#.#.##/GNS3.VM.VMware.ESXI.#.#.##.zip -OutFile "$PDQRepo\GNS3\GNS3.VM.VMware.ESXI.#.#.##.zip"
## Virtual Machine (VirtualBox)
#Invoke-WebRequest -Uri https://github.com/GNS3/gns3-gui/releases/download/v#.#.##/GNS3.VM.VirtualBox.#.#.##.zip -OutFile "$PDQRepo\GNS3\GNS3.VM.VirtualBox.#.#.##.zip"
## Virtual Machine (Hyper-V)
#Invoke-WebRequest -Uri https://github.com/GNS3/gns3-gui/releases/download/v#.#.##/GNS3.VM.Hyper-V.#.#.##.zip -OutFile "$PDQRepo\GNS3\GNS3.VM.Hyper-V.#.#.##.zip"

#Google Chrome Enterprise
#Invoke-WebRequest -Uri https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B042CAF80-AC3C-0299-4AC7-B307A61E85C8%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi -OutFile "$PDQRepo\Google Chrome Enterprise\chrome.enterprise.###.###.###.exe"

#JRE
#Invoke-WebRequest -Uri FOO -OutFile "BAH"

#Mozilla Firefox ESR
#Invoke-WebRequest -Uri https://download-installer.cdn.mozilla.net/pub/firefox/releases/##.#.#esr/win64/en-US/Firefox%20Setup%20##.#.#esr.exe -OutFile "$PDQRepo\Mozilla Firefox ESR\Firefox.Setup.##.#.#.esr.exe

#NMap
#Invoke-WebRequest -Uri https://nmap.org/dist/nmap-#.##-setup.exe -OutFile "$PDQRepo\NMap\nmap-#.##-setup.exe"

#NotepadPP
#Invoke-WebRequest -Uri https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v#.#.#/npp.#.#.#.Installer.x64.exe -OutFile "$PDQRepo\NotepadPP\npp.#.#.#.Installer.x64.exe"

#Npcap
#Invoke-WebRequest -Uri https://nmap.org/npcap/dist/npcap-#.####.exe -OutFile "$PDQRepo\Npcap\npcap-#.####.exe"

#PuTTY
#Invoke-WebRequest -Uri FOO -OutFile "BAH"
#ALTERNATE (MSI):
#Invoke-WebRequest -Uri http://mirror.aarnet.edu.au/pub/putty/putty-#.##/w64/putty-64bit-#.##-installer.msi -OutFile "$PDQRepo\PuTTY\putty-64bit-#.##-installer.msi"

#VeraCrypt
#Invoke-WebRequest -Uri https://launchpad.net/veracrypt/trunk/#.##-update#/+download/VeraCrypt%20Setup%20#.##-Update#.exe -OutFile "$PDQRepo\VeraCrypt\VeraCrypt%20Setup%20#.##-Update#.exe"

#Virtualbox
#Invoke-WebRequest -Uri https://download.virtualbox.org/virtualbox/#.#.##/VirtualBox-#.#.##-######-Win.exe -OutFile "$PDQRepo\VirtualBox\Virtualbox-#.#.##-######-Win.exe"

#Virtualbox Extension pack
#Invoke-WebRequest -Uri https://download.virtualbox.org/virtualbox/#.#.##/Oracle_VM_VirtualBox_Extension_Pack-#.#.##-######.vbox-extpack -OutFile "$PDQRepo\VirtualBox\Oracle_VM_VirtualBox_Extension_Pack-#.#.##-######.vbox-extpack"


#VLC
#Invoke-WebRequest -Uri http://mirror.aarnet.edu.au/pub/videolan/vlc/last/win64/vlc-3.0.11-win64.exe -OutFile "$PDQRepo\VLC\vlc-#.#.##-win64.exe"
#ALTERNATE (MSI):
#Invoke-WebRequest -Uri http://mirror.aarnet.edu.au/pub/videolan/vlc/last/win64/vlc-3.0.11-win64.msi -OutFile "$PDQRepo\VLC\vlc-#.#.##-win64.msi"

#VMware
#Invoke-WebRequest -Uri https://download3.vmware.com/software/wkst/file/VMware-workstation-full-##.#.#-########.exe -OutFile "$PDQRepo\VMware\VMware-workstation-full-##.#.#-########.exe"

#Wireshark
#Invoke-WebRequest -Uri https://2.na.dl.wireshark.org/win64/Wireshark-win64-#.#.#.exe -OutFile "$PDQRepo\Wireshark\Wireshark-win64-#.#.#.exe"
## ALTERNATE (EXE):
#Invoke-WebRequest -Uri https://mirror.aarnet.edu.au/pub/wireshark/win64/Wireshark-win64-#.#.##.exe -OutFile "$PDQRepo\Wireshark\Wireshark-win64-#.#.#.exe"
## ALTERNATE (MSI):
#Invoke-WebRequest -Uri https://mirror.aarnet.edu.au/pub/wireshark/win64/Wireshark-win64-#.#.##.msi -OutFile "$PDQRepo\Wireshark\Wireshark-win64-#.#.#.msi"

#ZAP
#Invoke-WebRequest -Uri https://github.com/zaproxy/zaproxy/releases/download/v#.#.#/ZAP_#_#_#_windows.exe -OutFile "$PDQRepo\ZAP\ZAP_#_#_#_windows.exe"

# Delete variables
Remove-Variable -Name "PDQRepo"