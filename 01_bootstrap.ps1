Function InitManagedVolumes() {

    # Change CDRom Drive to Z:
    Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' | Select-Object -First 1 | Set-WmiInstance -Arguments @{DriveLetter='Z:'}

    # Initialize the disks
    $disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number

    $letters = 69..89 | ForEach-Object { [char]$_ }
    $count = 0

    # Disabling hardware detection prompt
    Stop-Service -Name ShellHWDetection

    foreach ($disk in $disks) {
        $driveLetter = $letters[$count].ToString()
        $disk |
        Initialize-Disk -PartitionStyle MBR -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel "Data Disk $count" -Confirm:$false -Force
        $count++
    }

    # Disabling hardware detection prompt
    Start-Service -Name ShellHWDetection
}

# Executing Functions
InitManagedVolumes
