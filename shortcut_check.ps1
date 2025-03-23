
# 提取單個快捷方式的詳細信息
function Get-ShortcutDetails {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ShortcutPath
    )
    
    # 将相对路径转换为绝对路径
    $resolvedPath = Resolve-Path -Path $ShortcutPath -ErrorAction SilentlyContinue
    if (-not $resolvedPath) {
        Write-Error "無法解析路徑: $ShortcutPath"
        return
    }
    $ShortcutPath = $resolvedPath.Path

    # 檢查快捷方式是否存在
    if (-not (Test-Path $ShortcutPath)) {
        Write-Error "快捷方式不存在: $ShortcutPath"
        return
    }

    
    # 創建 COM 物件並讀取快捷方式信息
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($ShortcutPath)
    
    # 輸出快捷方式的屬性
    Write-Output "快捷方式路徑: $ShortcutPath"
    Write-Output "目標路徑: $($shortcut.TargetPath)"
    Write-Output "參數: $($shortcut.Arguments)"
    Write-Output "工作目錄: $($shortcut.WorkingDirectory)"
    Write-Output "圖標位置: $($shortcut.IconLocation)"
    Write-Output "快捷鍵: $($shortcut.Hotkey)"
    Write-Output "窗口樣式: $($shortcut.WindowStyle)"
    Write-Output "描述: $($shortcut.Description)"
    Write-Output "-----------------------------"
    
    # 釋放 COM 對象
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}

# 批量提取文件夾中所有快捷方式的詳細信息
function Get-AllShortcutsDetails {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )
    
    # 檢查文件夾是否存在
    if (-not (Test-Path $FolderPath)) {
        Write-Error "文件夾不存在: $FolderPath"
        return
    }
    
    # 獲取文件夾中的所有 .lnk 文件
    $shortcuts = Get-ChildItem -Path $FolderPath -Filter "*.lnk"
    
    # 遍歷每個快捷方式並提取詳細信息
    foreach ($shortcut in $shortcuts) {
        Get-ShortcutDetails -ShortcutPath $shortcut.FullName
    }
}

# 使用例子
# 提取單個快捷方式的詳細信息
# Get-ShortcutDetails -ShortcutPath "D:\Downloads\eleader\example.lnk"

# 提取文件夾中所有快捷方式的詳細信息
# Get-AllShortcutsDetails -FolderPath "D:\Downloads\eleader"

exit

# 提取單個快捷方式的詳細信息
function Get-ShortcutDetails {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ShortcutPath
    )
    
    # 檢查快捷方式是否存在
    if (-not (Test-Path $ShortcutPath)) {
        Write-Error "快捷方式不存在: $ShortcutPath"
        return
    }
    
    # 創建 COM 物件並讀取快捷方式信息
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($ShortcutPath)
    
    # 提取快捷方式的屬性
    $properties = @{
        "快捷方式路徑" = $ShortcutPath
        "目標路徑" = $shortcut.TargetPath
        "參數" = $shortcut.Arguments
        "工作目錄" = $shortcut.WorkingDirectory
        "描述" = $shortcut.Description
        "圖標位置" = $shortcut.IconLocation
        "快捷鍵" = $shortcut.Hotkey
        "窗口樣式" = $shortcut.WindowStyle
    }
    
    # 釋放 COM 對象
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    # 返回包含快捷方式信息的自定義對象
    return New-Object PSObject -Property $properties
}

# 批量提取文件夾中所有快捷方式的詳細信息
function Get-AllShortcutsDetails {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )
    
    # 檢查文件夾是否存在
    if (-not (Test-Path $FolderPath)) {
        Write-Error "文件夾不存在: $FolderPath"
        return
    }
    
    # 獲取文件夾中的所有 .lnk 文件
    $shortcuts = Get-ChildItem -Path $FolderPath -Filter "*.lnk"
    
    # 遍歷每個快捷方式並提取詳細信息
    foreach ($shortcut in $shortcuts) {
        Get-ShortcutDetails -ShortcutPath $shortcut.FullName
    }
}

# 使用例子
# 提取單個快捷方式的詳細信息
# Get-ShortcutDetails -ShortcutPath "D:\Downloads\eleader\example.lnk"

# 提取文件夾中所有快捷方式的詳細信息
# Get-AllShortcutsDetails -FolderPath "D:\Downloads\eleader"

exit

$folderPath = "D:\Downloads\eleader"
$shell = New-Object -ComObject WScript.Shell
Get-ChildItem -Path $folderPath -Filter *.lnk | ForEach-Object {
    $shortcut = $shell.CreateShortcut($_.FullName)

    # 提取並顯示快捷方式的資訊
    # Write-Host "快捷方式路徑: $($_.FullName)"
    Write-Host "快捷方式路徑: $($shortcut.FullName)"
    Write-Host "目標路徑: $($shortcut.TargetPath)"
    Write-Host "參數: $($shortcut.Arguments)"
    Write-Host "工作目錄: $($shortcut.WorkingDirectory)"
    Write-Host "圖標位置: $($shortcut.IconLocation)"
    Write-Host "快捷鍵: $($shortcut.Hotkey)"
    Write-Host "窗口樣式: $($shortcut.WindowStyle)"
    Write-Host "描述: $($shortcut.Description)"
    Write-Host "-----------------------------"
}

# 釋放 COM 物件
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

exit

# WindowStyle 屬性決定了程序運行時的窗口狀態。這個屬性對應於以下幾種常見的值：

# 值	描述
# 1	正常窗口（Normal）：程序以默認大小和位置啟動。
# 3	最大化窗口（Maximized）：程序啟動時窗口最大化。
# 7	最小化窗口（Minimized）：程序啟動時窗口最小化到任務欄。

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("D:\Downloads\eleader\Bonjour 印表機精靈.test1.lnk")
$shortcut.TargetPath = "C:\Windows\Installer\{0DA20600-6130-443B-9D4B-F30520315FA6}\PrinterSetupWizard_2.ico"
$shortcut.WindowStyle = 1  # 1 = 正常窗口, 3 = 最大化, 7 = 最小化
$shortcut.Save()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) | Out-Null

#---
$appsFolderItems = (New-Object -ComObject Shell.Application).NameSpace('shell:AppsFolder').Items()

# 顯示應用程序信息
foreach ($item in $appsFolderItems) {
    $appName = $item.Name
    $appPath = $item.Path
    
    Write-Host "應用名稱: $appName"
    Write-Host "應用路徑: $appPath"
    Write-Host "---------------------------"
}

# 應用名稱: 小算盤
# 應用路徑: Microsoft.WindowsCalculator_8wekyb3d8bbwe!App

# 應用名稱: Bonjour 印表機精靈
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Bonjour Print Services\PrinterWizard.exe


# 獲取小算盤應用信息
$appName = "小算盤"
$app = (New-Object -ComObject Shell.Application).NameSpace('shell:AppsFolder').Items() | 
        Where-Object { $_.Name -like "*$appName*" }

if ($app) {
    $app | ForEach-Object {
        # 基本信息
        $appId = $_.Path
        Write-Host "應用名稱: $($_.Name)"
        Write-Host "應用ID: $appId"
        
        # 獲取詳細屬性
        $shellFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:AppsFolder')
        
        # 通過遍歷所有可能的屬性索引來獲取信息
        for ($i = 0; $i -lt 400; $i++) {
            $propName = $shellFolder.GetDetailsOf($shellFolder.Items, $i)
            if ($propName) {
                $propValue = $shellFolder.GetDetailsOf($_, $i)
                if ($propValue) {
                    Write-Host "$propName : $propValue"
                }
            }
        }
    }
}

# # 查找特定應用程序 (例如: 計算器)
# $appName = "小算盤"
# $app = (New-Object -ComObject Shell.Application).NameSpace('shell:AppsFolder').Items() | 
#        Where-Object { $_.Name -like "*$appName*" }

# if ($app) {
#     # 獲取詳細信息
#     $app | ForEach-Object {
#         $appId = $_.Path
#         Write-Host "應用ID: $appId"
        
#         # 嘗試獲取更多屬性
#         $folderItem = $_ -as [System.Runtime.InteropServices.ComTypes.IShellItem]
#         # 可以進一步提取屬性
#     }
# }

# 獲取小算盤的 AppUserModelID
$calculatorApp = (New-Object -ComObject Shell.Application).NameSpace('shell:AppsFolder').Items() | 
                 Where-Object { $_.Name -like "*小算盤*" }

if ($calculatorApp) {
    $appId = $calculatorApp.Path
    Write-Host "找到小算盤應用，ID為: $appId"
    
    # 創建自定義啟動捷徑
    $shell = New-Object -ComObject WScript.Shell
    # $shortcutPath = "$env:USERPROFILE\Desktop\小算盤_科學計算器.lnk"
    $shortcutPath = "小算盤_科學計算器.lnk"
    $shortcut = $shell.CreateShortcut($shortcutPath)
    
    # 使用 explorer.exe 啟動 UWP 應用並傳遞協議參數
    $shortcut.TargetPath = "shell:AppsFolder\$appId"
    $shortcut.Arguments = "calculator://scientific"
    # 可選：設置圖標
    # $shortcut.IconLocation = "C:\Windows\System32\calc.exe,0"
    $shortcut.Save()
    
    # Write-Host "已在桌面創建捷徑: $shortcutPath"
    Write-Host "已創建捷徑: $shortcutPath"
}

# -----------------------
# $folderPath = "D:\Downloads\eleader"
# $shell = New-Object -ComObject WScript.Shell

# Get-ChildItem -Path $folderPath -Filter *.lnk | ForEach-Object {
#     try {
#         $shortcut = $shell.CreateShortcut($_.FullName)
#         if ($shortcut -ne $null) {
#             Write-Host "快捷方式: $($_.FullName)"
#             Write-Host "目標路徑: $($shortcut.TargetPath)"
#             Write-Host "圖標路徑: $($shortcut.IconLocation)"
#             Write-Host "-----------------------------"
#         } else {
#             Write-Warning "無法讀取快捷方式: $($_.FullName)"
#         }
#     } catch {
#         Write-Error "處理快捷方式時出錯: $($_.FullName)"
#     }
# }

# # 釋放 COM 物件
# [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
# [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) | Out-Null

# exit

# 應用名稱: 112年度綜合所得稅電子結算申報繳稅系統
# 應用路徑: C:\ETAX\IRX\Bin\IrxWin.exe
# ---------------------------
# 應用名稱: 解除安裝 112年度綜合所得稅電子結算申報繳稅系統
# 應用路徑: C:\ETAX\IRX\unins000.exe
# ---------------------------
# 應用名稱: Release notes
# 應用路徑: C:\ProgramData
# ---------------------------
# 應用名稱: 移除LINE
# 應用路徑: C:\Users\erik\AppData\Local\LINE\bin\LineUnInst.exe
# ---------------------------
# 應用名稱: Anki
# 應用路徑: C:\Users\erik\AppData\Local\Programs\Anki\anki.exe
# ---------------------------
# 應用名稱: QDir
# 應用路徑: C:\Users\erik\Documents\QDIR\Q-DirPortable.exe
# ---------------------------
# 應用名稱: readme
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap431_CH_BIG5\Help\readme.txt
# ---------------------------
# 應用名稱: uninstall
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap431_CH_BIG5\Help\uninstall.txt
# ---------------------------
# 應用名稱: web
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap431_CH_BIG5\Help\Web.htm
# ---------------------------
# 應用名稱: PhotoCap
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap431_CH_BIG5\PhotoCap.exe
# ---------------------------
# 應用名稱: readme
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap600_CH_BIG5\Help\readme.txt
# ---------------------------
# 應用名稱: uninstall
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap600_CH_BIG5\Help\uninstall.txt
# ---------------------------
# 應用名稱: web
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap600_CH_BIG5\Help\Web.htm
# ---------------------------
# 應用名稱: PhotoCap
# 應用路徑: C:\Users\erik\Downloads\PHOTO CAP\PhotoCap600_CH_BIG5\PhotoCap.exe
# ---------------------------
# 應用名稱: Google Chrome
# 應用路徑: Chrome
# ---------------------------
# 應用名稱: Google 密碼管理工具
# 應用路徑: Chrome._crx_kajebgjangfejcanhanjmmbcfd
# ---------------------------
# 應用名稱: GitKraken
# 應用路徑: com.squirrel.gitkraken.gitkraken
# ---------------------------
# 應用名稱: TreeSizeFree
# 應用路徑: Embarcadero.DesktopToasts.CB64A870
# ---------------------------
# 應用名稱: Visit our website
# 應用路徑: http://www.diskpart.com
# ---------------------------
# 應用名稱: Microsoft Support and Recovery Assistant 線上支援
# 應用路徑: https://aka.ms/SaRA_Home
# ---------------------------
# 應用名稱: Git FAQs (Frequently Asked Questions)
# 應用路徑: https://github.com/git-for-windows/git/wiki/FAQ
# ---------------------------
# 應用名稱: Logi Options+
# 應用路徑: Logi.OptionsPlus.App
# ---------------------------
# 應用名稱: Obsidian
# 應用路徑: md.obsidian
# ---------------------------
# 應用名稱: Microsoft 支援及修復小幫手
# 應用路徑: micr..tion_ac9f5adfc2cecd90_6a0b16b3f9a5a6a9
# ---------------------------
# 應用名稱: Reset Spyder Settings (beancount)
# 應用路徑: Microsoft.AutoGenerated.{036EF3CF-29CC-D7D4-9706-FFE9E6D752D0}
# ---------------------------
# 應用名稱: 效能監視器
# 應用路徑: Microsoft.AutoGenerated.{081BB5F4-CEF4-4295-0D5D-0A01ADA1B3CE}
# ---------------------------
# 應用名稱: Anaconda Prompt (beancount)
# 應用路徑: Microsoft.AutoGenerated.{0E85BC00-5A65-F2C8-1F8E-AA392AB2DD46}
# ---------------------------
# 應用名稱: Git Bash
# 應用路徑: Microsoft.AutoGenerated.{0FDD9C6B-656B-0F1F-AB08-B1CDBB7067B3}
# ---------------------------
# 應用名稱: Git Bash (jupyterlab)
# 應用路徑: Microsoft.AutoGenerated.{16373FA3-6523-1405-DDC4-4D475A18FDF9}
# ---------------------------
# 應用名稱: Anaconda Powershell Prompt (beancount)
# 應用路徑: Microsoft.AutoGenerated.{199A8F2C-B69D-9B3E-8154-2482ABD38102}
# ---------------------------
# 應用名稱: UXTerm (Ubuntu-22.04)
# 應用路徑: Microsoft.AutoGenerated.{1A0070F7-35BB-184C-4876-3D9A34F7D9E3}
# ---------------------------
# 應用名稱: Hyper-V 管理員
# 應用路徑: Microsoft.AutoGenerated.{257932F2-111C-114C-67E8-C41E7ED6E429}
# ---------------------------
# 應用名稱: Anaconda Powershell Prompt (py10)
# 應用路徑: Microsoft.AutoGenerated.{27A7900C-4D11-0C5D-C0A4-19E60B339928}
# ---------------------------
# 應用名稱: Git CMD
# 應用路徑: Microsoft.AutoGenerated.{29591C0F-7C09-B655-C0EB-8544FCA7D1DE}
# ---------------------------
# 應用名稱: Remove all class filters
# 應用路徑: Microsoft.AutoGenerated.{2E2E7E29-BD68-CAD2-2AEC-C73237EF7047}
# ---------------------------
# 應用名稱: Spyder (jupyterlab)
# 應用路徑: Microsoft.AutoGenerated.{38E506D3-EE99-CBCA-E48A-B1F42BFF346A}
# ---------------------------
# 應用名稱: 工作排程器
# 應用路徑: Microsoft.AutoGenerated.{39696563-32FE-A45B-1C0E-011DF64A4776}
# ---------------------------
# 應用名稱: Anaconda Powershell Prompt (miniconda3)
# 應用路徑: Microsoft.AutoGenerated.{396E2BDD-465B-ED68-9C85-87E61B0004A4}
# ---------------------------
# 應用名稱: 設定新酷音輸入法
# 應用路徑: Microsoft.AutoGenerated.{46690548-97BA-2F8A-B3E9-18BDA447C49A}
# ---------------------------
# 應用名稱: 工作管理員
# 應用路徑: Microsoft.AutoGenerated.{4A6E169C-2CC1-1F34-0DE9-D99366827535}
# ---------------------------
# 應用名稱: Windows 語音辨識
# 應用路徑: Microsoft.AutoGenerated.{4AE77DC5-982C-E629-0383-76AD53AD5130}
# ---------------------------
# 應用名稱: Install RELEASE (Ubuntu-22.04)
# 應用路徑: Microsoft.AutoGenerated.{4B333ABE-F85E-F26A-D5B5-E081CBFC55E1}
# ---------------------------
# 應用名稱: Command Prompt for vctl
# 應用路徑: Microsoft.AutoGenerated.{4F4AE827-2D2A-34D3-6A50-B2935D86B6EB}
# ---------------------------
# 應用名稱: Text Editor (Ubuntu-22.04)
# 應用路徑: Microsoft.AutoGenerated.{566A762A-11C0-0DA8-A554-EE1AE345AEFD}
# ---------------------------
# 應用名稱: Anaconda Powershell Prompt (jupyterlab)
# 應用路徑: Microsoft.AutoGenerated.{63970192-453A-E8DD-B6CA-746E3DFF1DA2}
# ---------------------------
# 應用名稱: Anaconda Prompt (py10)
# 應用路徑: Microsoft.AutoGenerated.{65478A5B-D299-9E4D-20B9-863D42581182}
# ---------------------------
# 應用名稱: Spyder (py10)
# 應用路徑: Microsoft.AutoGenerated.{6ED95927-4583-1F5E-1776-D1C99BD02FB1}
# ---------------------------
# 應用名稱: Start Service
# 應用路徑: Microsoft.AutoGenerated.{731F55E5-E930-43D7-1047-4DB0E5C7E2C9}
# ---------------------------
# 應用名稱: Reset Spyder Settings (py10)
# 應用路徑: Microsoft.AutoGenerated.{7588FB42-45F5-9109-2972-415FD5B536C3}
# ---------------------------
# 應用名稱: GVim (Ubuntu-22.04)
# 應用路徑: Microsoft.AutoGenerated.{782F1732-A725-8558-2A4F-0E6FA9021CFA}
# ---------------------------
# 應用名稱: Reset Spyder Settings (jupyterlab)
# 應用路徑: Microsoft.AutoGenerated.{8154D9AA-C1D3-CDA6-3357-3B3548359E8A}
# ---------------------------
# 應用名稱: Anaconda Prompt (jupyterlab)
# 應用路徑: Microsoft.AutoGenerated.{934FBFAA-0F2F-C8DD-CFC6-50116705A207}
# ---------------------------
# 應用名稱: 資源監視器
# 應用路徑: Microsoft.AutoGenerated.{978F5D51-DDF1-11D4-8E90-A57576987245}
# ---------------------------
# 應用名稱: Check For Updates
# 應用路徑: Microsoft.AutoGenerated.{9CA0093C-0300-05F8-F251-59E4250480AF}
# ---------------------------
# 應用名稱: Stop Service
# 應用路徑: Microsoft.AutoGenerated.{A55A804F-2057-81A7-F0A2-1089F273EB11}
# ---------------------------
# 應用名稱: 本機安全性原則
# 應用路徑: Microsoft.AutoGenerated.{B729AA26-FB96-7165-CBD6-1C9733CE5086}
# ---------------------------
# 應用名稱: 電腦管理
# 應用路徑: Microsoft.AutoGenerated.{C068E499-401A-2CFC-3C2E-9965A5271EFD}
# ---------------------------
# 應用名稱: Spyder (beancount)
# 應用路徑: Microsoft.AutoGenerated.{CB9BE6FD-D98F-D935-A159-20FB10D3860F}
# ---------------------------
# 應用名稱: Nmap - Zenmap GUI
# 應用路徑: Microsoft.AutoGenerated.{D2872DFE-4EC4-CD29-E597-62FB105E7FDA}
# ---------------------------
# 應用名稱: Anaconda Prompt (miniconda3)
# 應用路徑: Microsoft.AutoGenerated.{D8D791BF-21D1-8B21-1484-ACA0CDA7D36A}
# ---------------------------
# 應用名稱: XTerm (Ubuntu-22.04)
# 應用路徑: Microsoft.AutoGenerated.{DDE7D3D7-01D0-A28B-CD93-862733B4FF26}
# ---------------------------
# 應用名稱: 事件檢視器
# 應用路徑: Microsoft.AutoGenerated.{EAD50E1F-EFA2-530D-F85D-972ACA453BFD}
# ---------------------------
# 應用名稱: Install all class filters
# 應用路徑: Microsoft.AutoGenerated.{ECE20B14-DC1C-168F-BB74-A3055D7978F2}
# ---------------------------
# 應用名稱: 編輯新酷音使用者辭庫
# 應用路徑: Microsoft.AutoGenerated.{F952E3FB-6319-9F48-E753-12D03414E072}
# ---------------------------
# 應用名稱: Database Compare 2016
# 應用路徑: Microsoft.Office.DATABASECOMPARE.EXE.15
# ---------------------------
# 應用名稱: Excel 2016
# 應用路徑: Microsoft.Office.EXCEL.EXE.15
# ---------------------------
# 應用名稱: Office 2016 遙測記錄
# 應用路徑: Microsoft.Office.msoev.exe.15
# ---------------------------
# 應用名稱: Office 2016 遙測儀表板
# 應用路徑: Microsoft.Office.msotd.exe.15
# ---------------------------
# 應用名稱: Office 2016 上傳中心
# 應用路徑: Microsoft.Office.MSOUC.EXE.15
# ---------------------------
# 應用名稱: OneNote 2016
# 應用路徑: Microsoft.Office.ONENOTE.EXE.15
# ---------------------------
# 應用名稱: PowerPoint 2016
# 應用路徑: Microsoft.Office.POWERPNT.EXE.15
# ---------------------------
# 應用名稱: Office 2016 語言喜好設定
# 應用路徑: Microsoft.Office.SETLANG.EXE.15
# ---------------------------
# 應用名稱: Spreadsheet Compare 2016
# 應用路徑: Microsoft.Office.SPREADSHEETCOMPARE.EXE.15
# ---------------------------
# 應用名稱: Visio 2016
# 應用路徑: Microsoft.Office.VISIO.EXE.15
# ---------------------------
# 應用名稱: Project 2016
# 應用路徑: Microsoft.Office.WINPROJ.EXE.15
# ---------------------------
# 應用名稱: Word 2016
# 應用路徑: Microsoft.Office.WINWORD.EXE.15
# ---------------------------
# 應用名稱: PowerToys (Preview)
# 應用路徑: Microsoft.PowerToysWin32
# ---------------------------
# 應用名稱: OneDrive
# 應用路徑: Microsoft.SkyDrive.Desktop
# ---------------------------
# 應用名稱: Visual Studio Installer
# 應用路徑: Microsoft.VisualStudio.Installer
# ---------------------------
# 應用名稱: Visual Studio Code
# 應用路徑: Microsoft.VisualStudioCode
# ---------------------------
# 應用名稱: Windows 工具
# 應用路徑: Microsoft.Windows.AdministrativeTools
# ---------------------------
# 應用名稱: 控制台
# 應用路徑: Microsoft.Windows.ControlPanel
# ---------------------------
# 應用名稱: 檔案總管
# 應用路徑: Microsoft.Windows.Explorer
# ---------------------------
# 應用名稱: 遠端桌面連線
# 應用路徑: Microsoft.Windows.RemoteDesktop
# ---------------------------
# 應用名稱: 執行
# 應用路徑: Microsoft.Windows.Shell.RunDialog
# ---------------------------
# 應用名稱: WSL
# 應用路徑: Microsoft.WSL
# ---------------------------
# 應用名稱: Microsoft Edge
# 應用路徑: MSEdge
# ---------------------------
# 應用名稱: LINE
# 應用路徑: NAVER.WIN32_LINEwin8_8ptj331gd3tyt!LINE
# ---------------------------
# 應用名稱: NZXT CAM
# 應用路徑: NZXT.CAM
# ---------------------------
# 應用名稱: PuTTY
# 應用路徑: SimonTatham.PuTTY
# ---------------------------
# 應用名稱: VMware Workstation 16 Player
# 應用路徑: VMware.Workstation.vmplayer
# ---------------------------
# 應用名稱: VMware Workstation Pro
# 應用路徑: VMware.Workstation.vmui
# ---------------------------
# 應用名稱: 字元對應表
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\charmap.exe
# ---------------------------
# 應用名稱: 磁碟清理
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\cleanmgr.exe
# ---------------------------
# 應用名稱: 命令提示字元
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\cmd.exe
# ---------------------------
# 應用名稱: 元件服務
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\comexp.msc
# ---------------------------
# 應用名稱: 重組並最佳化磁碟機
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\dfrgui.exe
# ---------------------------
# 應用名稱: iSCSI 啟動器
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\iscsicpl.exe
# ---------------------------
# 應用名稱: 放大鏡
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\magnify.exe
# ---------------------------
# 應用名稱: Windows 記憶體診斷
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\MdSched.exe
# ---------------------------
# 應用名稱: 系統設定
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\msconfig.exe
# ---------------------------
# 應用名稱: 系統資訊
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\msinfo32.exe
# ---------------------------
# 應用名稱: 朗讀程式
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\narrator.exe
# ---------------------------
# 應用名稱: ODBC 資料來源 (64 位元)
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\odbcad32.exe
# ---------------------------
# 應用名稱: 螢幕小鍵盤
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\osk.exe
# ---------------------------
# 應用名稱: 步驟收錄程式
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\psr.exe
# ---------------------------
# 應用名稱: 快速助手
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\quickassist.exe
# ---------------------------
# 應用名稱: 修復磁碟機
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\RecoveryDrive.exe
# ---------------------------
# 應用名稱: 服務
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\services.msc
# ---------------------------
# 應用名稱: 具有進階安全性的 Windows Defender 防火牆
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WF.msc
# ---------------------------
# 應用名稱: Windows 傳真和掃描
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WFS.exe
# ---------------------------
# 應用名稱: Windows PowerShell
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe
# ---------------------------
# 應用名稱: Windows PowerShell ISE
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\PowerShell_ISE.exe
# ---------------------------
# 應用名稱: Windows Sandbox
# 應用路徑: {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsSandbox.exe
# ---------------------------
# 應用名稱: 7-Zip Help
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\7-Zip\7-zip.chm
# ---------------------------
# 應用名稱: 7-Zip File Manager
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\7-Zip\7zFM.exe
# ---------------------------
# 應用名稱: Bonjour 印表機精靈
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Bonjour Print Services\PrinterWizard.exe
# ---------------------------
# 應用名稱: 關於 Bonjour 列印服務
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Bonjour Print Services\PrinterWizard.Resources\zh_TW.lproj\About Bonjour Print Services.rtf
# ---------------------------
# 應用名稱: Logitech Unifying 3nAe
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Common Files\LogiShrd\Unifying\DJCUHost.exe
# ---------------------------
# 應用名稱: CrystalDiskInfo Shizuku Edition (32bit)
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\CrystalDiskInfo\DiskInfo32S.exe
# ---------------------------
# 應用名稱: CrystalDiskInfo Shizuku Edition (64bit)
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\CrystalDiskInfo\DiskInfo64S.exe
# ---------------------------
# 應用名稱: CrystalDiskMark 8 Shizuku Edition
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\CrystalDiskMark8\DiskMark64S.exe
# ---------------------------
# 應用名稱: spacedesk DRIVER Console
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\datronicsoft\spacedesk\spacedeskConsole.exe
# ---------------------------
# 應用名稱: Everything
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Everything\Everything.exe
# ---------------------------
# 應用名稱: FastCopy
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\FastCopy\FastCopy.exe
# ---------------------------
# 應用名稱: FreeFileSync
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\FreeFileSync\FreeFileSync.exe
# ---------------------------
# 應用名稱: RealTimeSync
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\FreeFileSync\RealTimeSync.exe
# ---------------------------
# 應用名稱: Git GUI
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Git\cmd\git-gui.exe
# ---------------------------
# 應用名稱: Git Release Notes
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Git\ReleaseNotes.html
# ---------------------------
# 應用名稱: Hyper-V 快速建立
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Hyper-V\VMCreate.exe
# ---------------------------
# 應用名稱: KeePass 2
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\KeePass Password Safe 2\KeePass.exe
# ---------------------------
# 應用名稱: Inf Wizard
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LibUSB-Win32\bin\inf-wizard.exe
# ---------------------------
# 應用名稱: Filter Wizard
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LibUSB-Win32\bin\install-filter-win.exe
# ---------------------------
# 應用名稱: Test (Win) Program
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LibUSB-Win32\bin\testlibusb-win.exe
# ---------------------------
# 應用名稱: GPL License
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LibUSB-Win32\COPYING_GPL.txt
# ---------------------------
# 應用名稱: LGPL License
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LibUSB-Win32\COPYING_LGPL.txt
# ---------------------------
# 應用名稱: Filter Console Help
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LibUSB-Win32\install-filter-help.txt
# ---------------------------
# 應用名稱: Listary
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Listary\Listary.exe
# ---------------------------
# 應用名稱: LockHunter
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LockHunter\LockHunter.exe
# ---------------------------
# 應用名稱: LockHunter on the Web
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\LockHunter\LockHunter.url
# ---------------------------
# 應用名稱: GeForce Experience
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\NVIDIA Corporation\NVIDIA GeForce Experience\NVIDIA GeForce Experience.exe
# ---------------------------
# 應用名稱: PSPad editor Help
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PSPad editor\PSPad.chm
# ---------------------------
# 應用名稱: PSPad editor
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PSPad editor\PSPad.exe
# ---------------------------
# 應用名稱: Visit PSPad editor homepage
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PSPad editor\PSPad.url
# ---------------------------
# 應用名稱: Uninstall PSPad editor
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PSPad editor\Uninst\unins000.exe
# ---------------------------
# 應用名稱: Pageant
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PuTTY\pageant.exe
# ---------------------------
# 應用名稱: PSFTP
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PuTTY\psftp.exe
# ---------------------------
# 應用名稱: PuTTY Manual
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PuTTY\putty.chm
# ---------------------------
# 應用名稱: PuTTYgen
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PuTTY\puttygen.exe
# ---------------------------
# 應用名稱: PuTTY Web Site
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\PuTTY\website.url
# ---------------------------
# 應用名稱: PDF-Viewer License
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Tracker Software\PDF Viewer\Help\PDFVLicense.pdf
# ---------------------------
# 應用名稱: PDF-Viewer Users Manual
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Tracker Software\PDF Viewer\Help\PDFVwrManSm.pdf
# ---------------------------
# 應用名稱: PDF-Viewer
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Tracker Software\PDF Viewer\PDFXCview.exe
# ---------------------------
# 應用名稱: Tracker Updater
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Tracker Software\Update\TrackerUpdate.exe
# ---------------------------
# 應用名稱: WordPad
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\Windows NT\Accessories\wordpad.exe
# ---------------------------
# 應用名稱: RAR 指令平台操作手冊
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\WinRAR\Rar.txt
# ---------------------------
# 應用名稱: 最新版本的新鮮事
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\WinRAR\WhatsNew.txt
# ---------------------------
# 應用名稱: WinRAR 說明
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\WinRAR\WinRAR.chm
# ---------------------------
# 應用名稱: WinRAR
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\WinRAR\WinRAR.exe
# ---------------------------
# 應用名稱: WSL Settings
# 應用路徑: {6D809377-6AF0-444B-8957-A3773F02200E}\WSL\wslsettings\wslsettings.exe
# ---------------------------
# 應用名稱: AirPort 工具程式
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AirPort\APUtil.exe
# ---------------------------
# 應用名稱: Air Video Server HD
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AirVideoServer HD\AirVideoServerStarter.exe
# ---------------------------
# 應用名稱: AllMyNotes Organizer
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AllMyNotes Organizer\AllMyNotes.exe
# ---------------------------
# 應用名稱: Help
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AllMyNotes Organizer\OnlineManual_AllMyNotesOrganzier.url
# ---------------------------
# 應用名稱: Uninstall
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AllMyNotes Organizer\Uninstall.exe
# ---------------------------
# 應用名稱: User Help
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AOMEI Partition Assistant\Help.exe
# ---------------------------
# 應用名稱: User Manual (PDF)
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AOMEI Partition Assistant\Manual.PDF
# ---------------------------
# 應用名稱: AOMEI Partition Assistant 9.13.0
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AOMEI Partition Assistant\PartAssist.exe
# ---------------------------
# 應用名稱: AutoIt Window Info (x86)
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\Au3Info.exe
# ---------------------------
# 應用名稱: AutoIt Window Info (x64)
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\Au3Info_x64.exe
# ---------------------------
# 應用名稱: Compile Script to .exe (x86)
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\Aut2Exe\Aut2exe.exe
# ---------------------------
# 應用名稱: Compile Script to .exe (x64)
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\Aut2Exe\Aut2exe_x64.exe
# ---------------------------
# 應用名稱: AutoIt v3 Website
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\AutoIt v3 Website.url
# ---------------------------
# 應用名稱: AutoIt Help File
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\AutoIt.chm
# ---------------------------
# 應用名稱: Run Script (x86)
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\AutoIt3.exe
# ---------------------------
# 應用名稱: Run Script (x64)
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\AutoIt3_x64.exe
# ---------------------------
# 應用名稱: VBScript Examples
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\AutoItX\ActiveX\VBScript
# ---------------------------
# 應用名稱: AutoItX Help File
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\AutoItX\AutoItX.chm
# ---------------------------
# 應用名稱: Examples
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\Examples
# ---------------------------
# 應用名稱: Browse Extras
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\Extras
# ---------------------------
# 應用名稱: SciTE Script Editor
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\AutoIt3\SciTE\SciTE.exe
# ---------------------------
# 應用名稱: DearMob iPhone Manager
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\DearMob\DearMob iPhone Manager\StartDearMobWin.exe
# ---------------------------
# 應用名稱: VideoProc Converter
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Digiarty\VideoProc Converter\VideoProcConverter.exe
# ---------------------------
# 應用名稱: FastStone Image Viewer
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\FastStone Image Viewer\FSViewer.exe
# ---------------------------
# 應用名稱: FastStone Image Viewer Help
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\FastStone Image Viewer\FSViewerHelp.chm
# ---------------------------
# 應用名稱: Visit www.FastStone.org
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\FastStone Image Viewer\Website.url
# ---------------------------
# 應用名稱: Kleopatra
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Gpg4win\bin\kleopatra.exe
# ---------------------------
# 應用名稱: Hard Disk Sentinel
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Hard Disk Sentinel\HDSentinel.exe
# ---------------------------
# 應用名稱: STM32 ST-LINK Utility User Manual
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\STMicroelectronics\STM32 ST-LINK Utility\Docs\ST-LINK Utility UM.pdf
# ---------------------------
# 應用名稱: ST-LINK User Manual
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\STMicroelectronics\STM32 ST-LINK Utility\Docs\STLink_UM.pdf
# ---------------------------
# 應用名稱: Overview of ST-LINK derivates
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\STMicroelectronics\STM32 ST-LINK Utility\Docs\TN1235.pdf
# ---------------------------
# 應用名稱: ST-LINK V2 User Manual
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\STMicroelectronics\STM32 ST-LINK Utility\Docs\UM1075.pdf
# ---------------------------
# 應用名稱: STM32 ST-LINK Utility
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\STM32 ST-LINK Utility.exe
# ---------------------------
# 應用名稱: Synology Active Backup for Business Agent
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Synology\ActiveBackupforBusinessAgent\ui\ui\Synology Active Backup for Business Agent.exe
# ---------------------------
# 應用名稱: Synology Assistant
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Synology\Assistant\DSAssistant.exe
# ---------------------------
# 應用名稱: Synology Drive Client
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Synology\SynologyDrive\bin\launcher.exe
# ---------------------------
# 應用名稱: Virtual Network Editor
# 應用路徑: {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\VMware\VMware Workstation\vmnetcfg.exe
# ---------------------------
# 應用名稱: ODBC Data Sources (32-bit)
# 應用路徑: {D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}\odbcad32.exe
# ---------------------------
# 應用名稱: Windows PowerShell (x86)
# 應用路徑: {D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}\WindowsPowerShell\v1.0\powershell.exe
# ---------------------------
# 應用名稱: Windows PowerShell ISE (x86)
# 應用路徑: {D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}\WindowsPowerShell\v1.0\PowerShell_ISE.exe
# ---------------------------
# 應用名稱: 登錄編輯程式
# 應用路徑: {F38BF404-1D43-42F2-9305-67DE0B28FC23}\regedit.exe
# ---------------------------
# 應用名稱: Microsoft Edge
# 應用路徑: Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge
# ---------------------------
# 應用名稱: 設定
# 應用路徑: windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel
# ---------------------------
# 應用名稱: LINE
# 應用路徑: NAVER.LINEwin8_8ptj331gd3tyt!LINE
# ---------------------------
# 應用名稱: 入門
# 應用路徑: MicrosoftWindows.Client.CBS_cw5n1h2txyewy!WebExperienceHost
# ---------------------------
# 應用名稱: Cortana
# 應用路徑: Microsoft.549981C3F5F10_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 新聞
# 應用路徑: Microsoft.BingNews_8wekyb3d8bbwe!AppexNews
# ---------------------------
# 應用名稱: Microsoft To Do
# 應用路徑: Microsoft.Todos_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Windows 錄音機
# 應用路徑: Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 取得協助
# 應用路徑: Microsoft.GetHelp_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 自黏便箋
# 應用路徑: Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 意見反應中樞
# 應用路徑: Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 地圖
# 應用路徑: Microsoft.WindowsMaps_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 天氣
# 應用路徑: Microsoft.BingWeather_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Windows 安全性
# 應用路徑: Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI
# ---------------------------
# 應用名稱: Solitaire & Casual Games
# 應用路徑: Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Ubuntu
# 應用路徑: CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc!ubuntu
# ---------------------------
# 應用名稱: Adobe Express
# 應用路徑: AdobeSystemsIncorporated.AdobeCreativeCloudExpress_ynb6jyjzte8ga!App
# ---------------------------
# 應用名稱: 提示
# 應用路徑: Microsoft.Getstarted_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Ubuntu 22.04.5 LTS
# 應用路徑: CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc!ubuntu2204
# ---------------------------
# 應用名稱: 遠端桌面
# 應用路徑: Microsoft.RemoteDesktop_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 終端機
# 應用路徑: Microsoft.WindowsTerminal_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 郵件
# 應用路徑: microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail
# ---------------------------
# 應用名稱: 行事曆
# 應用路徑: microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar
# ---------------------------
# 應用名稱: NVIDIA Control Panel
# 應用路徑: NVIDIACorp.NVIDIAControlPanel_56jybvy8sckqj!NVIDIACorp.NVIDIAControlPanel
# ---------------------------
# 應用名稱: 電影與電視
# 應用路徑: Microsoft.ZuneVideo_8wekyb3d8bbwe!Microsoft.ZuneVideo
# ---------------------------
# 應用名稱: 記事本
# 應用路徑: Microsoft.WindowsNotepad_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Game Bar
# 應用路徑: Microsoft.XboxGamingOverlay_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 時鐘
# 應用路徑: Microsoft.WindowsAlarms_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 相片
# 應用路徑: Microsoft.Windows.Photos_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 小算盤
# 應用路徑: Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 媒體播放器
# 應用路徑: Microsoft.ZuneMusic_8wekyb3d8bbwe!Microsoft.ZuneMusic
# ---------------------------
# 應用名稱: 相機
# 應用路徑: Microsoft.WindowsCamera_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: 小畫家
# 應用路徑: Microsoft.Paint_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: iTunes
# 應用路徑: AppleInc.iTunes_nzyj5cx40ttqa!iTunes
# ---------------------------
# 應用名稱: Microsoft Clipchamp
# 應用路徑: Clipchamp.Clipchamp_yxz26nhyzhsrt!App
# ---------------------------
# 應用名稱: WinDbg
# 應用路徑: Microsoft.WinDbg_8wekyb3d8bbwe!Microsoft.WinDbg
# ---------------------------
# 應用名稱: 手機連結
# 應用路徑: Microsoft.YourPhone_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Messenger
# 應用路徑: FACEBOOK.317180B0BB486_8xx8rvfyw5nnt!App
# ---------------------------
# 應用名稱: 剪取工具
# 應用路徑: Microsoft.ScreenSketch_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Spotify
# 應用路徑: SpotifyAB.SpotifyMusic_zpdnekdrzrea0!Spotify
# ---------------------------
# 應用名稱: Microsoft Store
# 應用路徑: Microsoft.WindowsStore_8wekyb3d8bbwe!App
# ---------------------------
# 應用名稱: Outlook (new)
# 應用路徑: Microsoft.OutlookForWindows_8wekyb3d8bbwe!Microsoft.OutlookforWindows
# ---------------------------
# 應用名稱: Snipaste
# 應用路徑: 45479liulios.17062D84F7C46_p7pnf6hceqser!Snipaste
# ---------------------------
# 應用名稱: Power Automate
# 應用路徑: Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe!PAD.Console
# ---------------------------