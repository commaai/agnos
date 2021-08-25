$fastboot = "platform-tools/fastboot.exe"
if (Test-Path -path $fastboot) {
    Write-Host 'Platform tools found';
} else {
    Write-Host 'Downloading platform tools';

    $client = new-object System.Net.WebClient
    $client.DownloadFile("https://dl.google.com/android/repository/platform-tools_r28.0.2-windows.zip", "platform-tools.zip")

    Write-Host 'Extracting platform tools';
    Expand-Archive -Path "platform-tools.zip" -DestinationPath "." -Force

    Remove-Item "platform-tools.zip"
}

Invoke-Expression "$($fastboot) --set-active=a"
Invoke-Expression "$($fastboot) flash xbl_a xbl.img"
Invoke-Expression "$($fastboot) flash xbl_config_a xbl_config.img"
Invoke-Expression "$($fastboot) flash abl_a abl.img"
Invoke-Expression "$($fastboot) flash boot_a boot.img"
Invoke-Expression "$($fastboot) flash system_a system.img"

Invoke-Expression "$($fastboot) format:ext4 userdata"
Invoke-Expression "$($fastboot) format cache"
Invoke-Expression "$($fastboot) continue"


Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');