
function Get-ShortcutRawData {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ShortcutPath
    )
    
    if (-not (Test-Path $ShortcutPath)) {
        Write-Error "快捷方式不存在: $ShortcutPath"
        return
    }
    
    # 創建輸出對象
    $result = [PSCustomObject]@{
        Path = (Resolve-Path $ShortcutPath).Path
        HexDump = @()
        ASCIIStrings = @()
        UTF8Strings = @()
        UTF16Strings = @()
    }
    
    # 讀取快捷方式文件的二進制數據
    $bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $ShortcutPath))
    
    # 顯示整個文件的十六進制和ASCII表示
    $fileSizeInfo = "文件大小: $($bytes.Length) 字節"
    $result.HexDump += $fileSizeInfo
    
    # 處理十六進制和ASCII轉儲
    $ascii = ""
    $hexOutput = ""
    $stringBuffer = New-Object System.Collections.ArrayList
    
    for ($i = 0; $i -lt $bytes.Length; $i++) {
        $byte = $bytes[$i]
        $hexOutput += "{0:X2} " -f $byte
        
        # 如果是可打印ASCII字符，則添加到字符串緩衝區
        if ($byte -ge 32 -and $byte -le 126) {
            $ascii += [char]$byte
            $stringBuffer.Add([char]$byte) | Out-Null
        }
        else {
            $ascii += "."
            # 如果遇到非可打印字符，並且緩沖區已經有內容，將其輸出
            if ($stringBuffer.Count -gt 4) {
                $string = -join $stringBuffer
                $result.ASCIIStrings += $string
            }
            $stringBuffer.Clear()
        }
        
        # 每16字節顯示一行
        if (($i + 1) % 16 -eq 0 -or $i -eq $bytes.Length - 1) {
            # 補全最後一行
            if ($i -eq $bytes.Length - 1) {
                $padding = 16 - (($i + 1) % 16)
                if ($padding -lt 16) {
                    $hexOutput += " " * ($padding * 3)
                }
            }
            
            $dumpLine = "{0:X8}: {1} {2}" -f ($i - (($i) % 16)), $hexOutput, $ascii
            $result.HexDump += $dumpLine
            $hexOutput = ""
            $ascii = ""
        }
    }
    
    # 提取 ASCII 字符串 (連續 5 個以上可打印字符)
    $asciiBuffer = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt $bytes.Length; $i++) {
        if ($bytes[$i] -ge 32 -and $bytes[$i] -le 126) {
            $asciiBuffer.Add([char]$bytes[$i]) | Out-Null
        }
        else {
            if ($asciiBuffer.Count -gt 4) {
                $result.ASCIIStrings += -join $asciiBuffer
            }
            $asciiBuffer.Clear()
        }
    }
    
    # 提取 UTF-8 字符串
    $utf8Buffer = New-Object System.Collections.ArrayList
    $i = 0
    while ($i -lt $bytes.Length) {
        # 檢查是否為有效的 UTF-8 字符
        if ($bytes[$i] -lt 128) {
            # ASCII 範圍
            if ($bytes[$i] -ge 32 -and $bytes[$i] -le 126) {
                $utf8Buffer.Add([char]$bytes[$i]) | Out-Null
                $i++
            }
            else {
                if ($utf8Buffer.Count -gt 4) {
                    $result.UTF8Strings += -join $utf8Buffer
                }
                $utf8Buffer.Clear()
                $i++
            }
        }
        elseif ($i + 1 -lt $bytes.Length -and ($bytes[$i] -band 0xE0) -eq 0xC0 -and ($bytes[$i+1] -band 0xC0) -eq 0x80) {
            # 2-byte UTF-8
            try {
                $char = [System.Text.Encoding]::UTF8.GetString($bytes[$i..($i+1)])
                $utf8Buffer.Add($char) | Out-Null
            }
            catch {
                # 忽略無效的 UTF-8 序列
            }
            $i += 2
        }
        elseif ($i + 2 -lt $bytes.Length -and ($bytes[$i] -band 0xF0) -eq 0xE0 -and 
                ($bytes[$i+1] -band 0xC0) -eq 0x80 -and ($bytes[$i+2] -band 0xC0) -eq 0x80) {
            # 3-byte UTF-8
            try {
                $char = [System.Text.Encoding]::UTF8.GetString($bytes[$i..($i+2)])
                $utf8Buffer.Add($char) | Out-Null
            }
            catch {
                # 忽略無效的 UTF-8 序列
            }
            $i += 3
        }
        elseif ($i + 3 -lt $bytes.Length -and ($bytes[$i] -band 0xF8) -eq 0xF0 -and 
                ($bytes[$i+1] -band 0xC0) -eq 0x80 -and ($bytes[$i+2] -band 0xC0) -eq 0x80 -and 
                ($bytes[$i+3] -band 0xC0) -eq 0x80) {
            # 4-byte UTF-8
            try {
                $char = [System.Text.Encoding]::UTF8.GetString($bytes[$i..($i+3)])
                $utf8Buffer.Add($char) | Out-Null
            }
            catch {
                # 忽略無效的 UTF-8 序列
            }
            $i += 4
        }
        else {
            if ($utf8Buffer.Count -gt 4) {
                $result.UTF8Strings += -join $utf8Buffer
            }
            $utf8Buffer.Clear()
            $i++
        }
    }
    
    # 提取 UTF-16 LE 字符串
    $utf16Buffer = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt $bytes.Length - 1; $i += 2) {
        if ($i + 1 -lt $bytes.Length) {
            try {
                $codePoint = [System.BitConverter]::ToUInt16($bytes, $i)
                if (($codePoint -ge 0x20 -and $codePoint -le 0x7E) -or ($codePoint -ge 0x4E00 -and $codePoint -le 0x9FFF)) {
                    # 可打印 ASCII 或常見中文字符範圍
                    $char = [System.BitConverter]::ToChar($bytes, $i)
                    $utf16Buffer.Add($char) | Out-Null
                }
                else {
                    if ($utf16Buffer.Count -gt 4) {
                        $result.UTF16Strings += -join $utf16Buffer
                    }
                    $utf16Buffer.Clear()
                }
            }
            catch {
                if ($utf16Buffer.Count -gt 4) {
                    $result.UTF16Strings += -join $utf16Buffer
                }
                $utf16Buffer.Clear()
            }
        }
    }
    
    # 清理並去重
    $result.ASCIIStrings = $result.ASCIIStrings | Sort-Object -Unique | Where-Object { $_.Length -gt 4 }
    $result.UTF8Strings = $result.UTF8Strings | Sort-Object -Unique | Where-Object { $_.Length -gt 4 }
    $result.UTF16Strings = $result.UTF16Strings | Sort-Object -Unique | Where-Object { $_.Length -gt 4 }
    
    return $result
}

function Get-ShortcutInfo {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ShortcutPath
    )
    
    $rawData = Get-ShortcutRawData -ShortcutPath $ShortcutPath
    
    # 輸出結果
    Write-Output "分析快捷方式: $($rawData.Path)"
    Write-Output "------------------------"
    Write-Output "十六進制轉儲:"
    $rawData.HexDump | ForEach-Object { Write-Output $_ }
    
    Write-Output "------------------------"

    Write-Output "提取的字符串:"
    $rawData.ExtractedStrings | ForEach-Object { Write-Output $_ }
    Write-Output "------------------------"

    # Write-Output "提取的字符串:"

    # Write-Output "ASCII 字符串:"
    # $rawData.ASCIIStrings | ForEach-Object { Write-Output $_ }
    
    # Write-Output "------------------------"
    # Write-Output "UTF-8 字符串:"
    # $rawData.UTF8Strings | ForEach-Object { Write-Output $_ }
    
    # Write-Output "------------------------"
    # Write-Output "UTF-16 LE 字符串:"
    # $rawData.UTF16Strings | ForEach-Object { Write-Output $_ }
    
    # Write-Output "------------------------"
}

function Get-AllShortcutsInfo {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )
    
    if (-not (Test-Path $FolderPath)) {
        Write-Error "文件夾不存在: $FolderPath"
        return
    }
    
    $shortcuts = Get-ChildItem -Path $FolderPath -Filter "*.lnk"
    
    foreach ($shortcut in $shortcuts) {
        Get-ShortcutInfo -ShortcutPath $shortcut.FullName
    }
}

# 使用例子
# Get-ShortcutInfo -ShortcutPath ".\小算盤_科學計算器.lnk"
# Get-AllShortcutsInfo -FolderPath "C:\Users\Username\Desktop"
