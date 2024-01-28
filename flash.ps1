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

$edl = "edl/edl"
if (Test-Path -path $edl) {
    Write-Host 'EDL tool found'
} else {
    Write-Host "Downloading and setting up EDL"
    git clone https://github.com/bkerler/edl.git edl
    cd edl
    git submodule update --depth=1 --init --recursive
    Invoke-Expression "python -m pip3 install requirements.txt"
    cd ..

    Write-Host "Downloading and setting up UsbDk"
    $client = new-object System.Net.WebClient
    $client.DownloadFile("https://github.com/daynix/UsbDk/releases/download/v1.00-22/UsbDk_1.0.22_x86.msi", "UsbDk_1.0.22_x86.msi")
    Start-Process -FilePath msiexec.exe -ArgumentList "/i UsbDk_1.0.22_x86.msi /qn"
    Remove-Item "UsbDk_1.0.22_x86.msi"
}

Invoke-Expression "$($edl) setactiveslot a --serial"
Invoke-Expression "$($edl) w devcfg_a devcfg.img --serial"
Invoke-Expression "$($edl) w aop_a aop.img --serial --serial"
Invoke-Expression "$($edl) w xbl_a xbl.img --serial"
Invoke-Expression "$($edl) w xbl_config_a xbl_config.img --serial"
Invoke-Expression "$($edl) w abl_a abl.img --serial"
Invoke-Expression "$($edl) w boot_a boot.img --serial"
Invoke-Expression "$($edl) w system_a system.img --serial"

Invoke-Expression "$($fastboot) format:ext4 userdata"
Invoke-Expression "$($fastboot) format cache"
Invoke-Expression "$($fastboot) continue"

Write-Host 'AGNOS flash successful.';