$edl = "edl_repo/edl"
if (Test-Path -path $edl) {
    Write-Host 'EDL tool found'
} else {
    Write-Host "Downloading and setting up EDL"
    Invoke-Expression "git clone https://github.com/bkerler/edl.git edl_repo"
    Invoke-Expression "cd edl_repo"
    Invoke-Expression "git submodule update --depth=1 --init --recursive"
    Invoke-Expression "python -m pip3 install requirements.txt"
    Invoke-Expression "cd .."

    Write-Host "Downloading and setting up UsbDk"
    $client = new-object System.Net.WebClient
    $client.DownloadFile("https://github.com/daynix/UsbDk/releases/download/v1.00-22/UsbDk_1.0.22_x86.msi", "UsbDk_1.0.22_x86.msi")
    Start-Process -FilePath msiexec.exe -ArgumentList "/i UsbDk_1.0.22_x86.msi /qn"
    Remove-Item "UsbDk_1.0.22_x86.msi"
}

Invoke-Expression "$($edl) setactiveslot a"
Invoke-Expression "$($edl) w devcfg_a devcfg.img"
Invoke-Expression "$($edl) w aop_a aop.img"
Invoke-Expression "$($edl) w xbl_a xbl.img"
Invoke-Expression "$($edl) w xbl_config_a xbl_config.img"
Invoke-Expression "$($edl) w abl_a abl.img"
Invoke-Expression "$($edl) w boot_a boot.img"
Invoke-Expression "$($edl) w system_a system.img"

Invoke-Expression "$($edl) e userdata"
Invoke-Expression "$($edl) e cache"
Invoke-Expression "$($edl) reset"

Write-Host 'AGNOS flash successful.';