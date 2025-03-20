Add-Type -AssemblyName System.Windows.Forms

$dataObj = [System.Windows.Forms.Clipboard]::GetDataObject()
if ($null -eq $dataObj) { 
    Write-Host "剪贴板为空"
    exit
}

Write-Host "`n剪贴板包含的格式 ($($dataObj.GetFormats().Count)):"
$dataObj.GetFormats() | ForEach-Object {
    Write-Host "`n=== 格式: $_ ==="
    try {
        $data = $dataObj.GetData($_)
        if ($data -is [System.IO.MemoryStream]) {
            $bytes = $data.ToArray()
            Write-Host "二进制数据 (长度: $($bytes.Length) bytes)"
            Write-Host "Hex 开头: $(-join $bytes[0..7] | ForEach-Object { $_.ToString('X2') })"
        }
        elseif ($data -is [string[]]) {
            Write-Host "字符串数组:"
            $data | ForEach-Object { "  [$_]" }
        }
        else {
            $data
        }
    }
    catch {
        Write-Host "无法读取此格式内容"
    }
}


return
exit

$clipboardContent = Get-Clipboard
$clipboardContent | Out-File -FilePath "C:\temp\saved_clipboard.txt"

$savedContent = Get-Content -Path "C:\temp\saved_clipboard.txt"
$savedContent | Set-Clipboard


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Runtime.Serialization.Formatters.Binary

function Save-Clipboard {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    $dataObj = [System.Windows.Forms.Clipboard]::GetDataObject()
    if ($null -eq $dataObj) { return }

    $formatter = [System.Runtime.Serialization.Formatters.Binary.BinaryFormatter]::new()
    $stream = [System.IO.MemoryStream]::new()
    $formatter.Serialize($stream, $dataObj)
    $stream.ToArray() | Set-Content -Path $Path -Encoding Byte
}

function Restore-Clipboard {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    $bytes = Get-Content -Path $Path -Encoding Byte -Raw
    if (-not $bytes) { return }

    $formatter = [System.Runtime.Serialization.Formatters.Binary.BinaryFormatter]::new()
    $stream = [System.IO.MemoryStream]::new($bytes)
    $dataObj = $formatter.Deserialize($stream)
    [System.Windows.Forms.Clipboard]::SetDataObject($dataObj)
}

# # 使用示例
# Save-Clipboard -Path "clipboard.bin"
# Restore-Clipboard -Path "clipboard.bin"
