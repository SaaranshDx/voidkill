# VOIDKILL.ps1 - Advanced Terminal-based Task Manager & Network Toolkit 
#made by Saaransh_Xd
#window config
$width = 162
$height = 50

# Set window size
$targethost.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($width, $height)

# Set buffer size (prevents scrollbars)
$targethost.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size($width, $height)


#emoji rendering
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$mainOptions = @("🔥 VOIDKILL Task Manager  ", "🌐 Network Toolkit  ", "ℹ️  About VOIDKILL   ", "❌ Exit ")
$mainSelected = 0

# Task Manager Variables
$taskOptions = @("📜 List Processes", "❌ Kill Process by Name", "❌ Kill Process by PID", "🪦 RUN BREAK SEQUENCE" , "📖 About VOIDKILL", "🔙 Back to Main Menu")
$taskSelected = 0

# Network Toolkit Variables
$netOptions = @("➡️  Domain → IP", "📶  View Active Connections", "📡 Scan Connected Devices (LAN)", "🔎 IP Lookup (Location, ISP)", "🛜  Ping a Host", "🔙 Back to Main Menu")
$netSelected = 0

function Show-MainHeader {
    Write-Host @"
            .__    .___  __   .__.__  .__   
  ___  ______ |__| __| _/ |  | _|__|  | |  |  
  \  \/ /  _ \|  |/ __ |  |  |/ /  |  | |  |  
   \   (  <_> )  / /_/ |  |    <|  |  |_|  |__
    \_/ \____/|__\____ |  |__|_ \__|____/____/
                        \/       \/              
        VOIDKILL :: Ultimate Terminal Toolkit
"@ -ForegroundColor Magenta
}

function Show-TaskHeader {
    Write-Host @"
            .__    .___  __   .__.__  .__   
  ___  ______ |__| __| _/ |  | _|__|  | |  |  
  \  \/ /  _ \|  |/ __ |  |  |/ /  |  | |  |  
   \   (  <_> )  / /_/ |  |    <|  |  |_|  |__
    \_/ \____/|__\____ |  |__|_ \__|____/____/
                        \/       \/              
    VOIDKILL :: the final process begins...
"@ -ForegroundColor Red
}

function Show-NetHeader {
    Write-Host @"
            .__    .___  __   .__.__  .__   
  ___  ______ |__| __| _/ |  | _|__|  | |  |  
  \  \/ /  _ \|  |/ __ |  |  |/ /  |  | |  |  
   \   (  <_> )  / /_/ |  |    <|  |  |_|  |__
    \_/ \____/|__\____ |  |__|_ \__|____/____/
                        \/       \/                                                                                     
    NETWORK TOOLKIT :: Connectivity Arsenal
"@ -ForegroundColor Cyan
}

function Draw-MainMenu {
    Clear-Host
    Show-MainHeader
    Write-Host "`n┌─────────── VOIDKILL MAIN MENU ───────────┐"
    for ($i = 0; $i -lt $mainOptions.Length; $i++) {
        if ($i -eq $mainSelected) {
            Write-Host ("│ > " + $mainOptions[$i].PadRight(36) + "│") -ForegroundColor Yellow
        } else {
            Write-Host ("│   " + $mainOptions[$i].PadRight(36) + "│")
        }
    }
    Write-Host "└─────────────────────────────────────────┘"
    Write-Host "`nUse ↑/↓ arrows to navigate, Enter to select" -ForegroundColor Gray
}

function Draw-TaskMenu {
    Clear-Host
    Show-TaskHeader
    Write-Host "`n┌────────── VOIDKILL MENU ──────────┐"
    for ($i = 0; $i -lt $taskOptions.Length; $i++) {
        if ($i -eq $taskSelected) {
            Write-Host ("│ > " + $taskOptions[$i].PadRight(32) + "│") -ForegroundColor Cyan
        } else {
            Write-Host ("│   " + $taskOptions[$i].PadRight(32) + "│")
        }
    }
    Write-Host "└───────────────────────────────────┘"
    Write-Host "`nUse ↑/↓ arrows to navigate, Enter to select" -ForegroundColor Gray
}

function Draw-NetMenu {
    Clear-Host
    Show-NetHeader
    Write-Host "`n┌──────── NETWORK TOOLKIT MENU ────────┐"
    for ($i = 0; $i -lt $netOptions.Length; $i++) {
        if ($i -eq $netSelected) {
            Write-Host ("│ > " + $netOptions[$i].PadRight(34) + "│") -ForegroundColor Green
        } else {
            Write-Host ("│   " + $netOptions[$i].PadRight(34) + "│")
        }
    }
    Write-Host "└───────────────────────────────────────┘"
    Write-Host "`nUse ↑/↓ arrows to navigate, Enter to select" -ForegroundColor Gray
}

# ================ TASK MANAGER FUNCTIONS ================

function List-Processes {
    $processes = Get-Process | Sort-Object -Descending CPU | Select-Object -First 20 Id, ProcessName, CPU, PM
    $processSelected = 0
    
    function Draw-ProcessList {
        Clear-Host
        Show-TaskHeader
        Write-Host "`n📋 TOP 20 PROCESSES BY CPU USAGE - NAVIGATE & KILL:" -ForegroundColor Yellow
        Write-Host "┌─────┬────────────────────────┬─────────────┬─────────────┐"
        Write-Host "│ PID │ Process Name           │ CPU         │ Memory (MB) │"
        Write-Host "├─────┼────────────────────────┼─────────────┼─────────────┤"
        
        for ($i = 0; $i -lt $processes.Length; $i++) {
            $process = $processes[$i]
            $processId = $process.Id.ToString().PadRight(4)
            $name = $process.ProcessName.PadRight(22)
            $cpu = if ($process.CPU) { [math]::Round($process.CPU, 2).ToString().PadRight(11) } else { "N/A".PadRight(11) }
            $memory = [math]::Round($process.PM / 1MB, 2).ToString().PadRight(11)
            
            if ($i -eq $processSelected) {
                Write-Host "│ $processId│ $name│ $cpu│ $memory│" -ForegroundColor Black -BackgroundColor Cyan
            } else {
                Write-Host "│ $processId│ $name│ $cpu│ $memory│"
            }
        }
        Write-Host "└─────┴────────────────────────┴─────────────┴─────────────┘"
        Write-Host "`n🎯 Selected: $($processes[$processSelected].ProcessName) (PID: $($processes[$processSelected].Id))" -ForegroundColor Cyan
        Write-Host "↑/↓: Navigate | Enter: Kill Process | R: Refresh | Esc: Back to Menu" -ForegroundColor Gray
    }
    
    while ($true) {
        Draw-ProcessList
        $key = [System.Console]::ReadKey($true)
        switch ($key.Key) {
            'UpArrow' { 
                $processSelected = ($processSelected - 1 + $processes.Length) % $processes.Length 
            }
            'DownArrow' { 
                $processSelected = ($processSelected + 1) % $processes.Length 
            }
            'Enter' {
                $selectedProcess = $processes[$processSelected]
                Clear-Host
                Show-TaskHeader
                Write-Host "`n⚠️  KILL CONFIRMATION" -ForegroundColor Red
                Write-Host "You are about to terminate:" -ForegroundColor Yellow
                Write-Host "Process: $($selectedProcess.ProcessName)" -ForegroundColor White
                Write-Host "PID: $($selectedProcess.Id)" -ForegroundColor White
                Write-Host "Memory: $([math]::Round($selectedProcess.PM / 1MB, 2)) MB" -ForegroundColor White
                Write-Host "`nAre you sure? (Y/N): " -NoNewline -ForegroundColor Red
                
                $confirm = [System.Console]::ReadKey($true)
                if ($confirm.Key -eq 'Y') {
                    try {
                        Stop-Process -Id $selectedProcess.Id -Force
                        Write-Host "`n✔ Process '$($selectedProcess.ProcessName)' (PID: $($selectedProcess.Id)) terminated!" -ForegroundColor Green
                        $processes = Get-Process | Sort-Object -Descending CPU | Select-Object -First 20 Id, ProcessName, CPU, PM
                        if ($processSelected -ge $processes.Length) {
                            $processSelected = $processes.Length - 1
                        }
                    } catch {
                        Write-Host "`n✘ Failed to kill '$($selectedProcess.ProcessName)' - $($_.Exception.Message)" -ForegroundColor Red
                    }
                    Write-Host "Press any key to continue..." -ForegroundColor Gray
                    [System.Console]::ReadKey($true) | Out-Null
                } else {
                    Write-Host "`nOperation cancelled." -ForegroundColor Yellow
                    Start-Sleep 1
                }
            }
            'Escape' { 
                return 
            }
            'R' {
                $processes = Get-Process | Sort-Object -Descending CPU | Select-Object -First 20 Id, ProcessName, CPU, PM
                $processSelected = 0
            }
        }
    }
}

function Kill-By-Name {
    Clear-Host
    Show-TaskHeader
    Write-Host "`n🎯 KILL BY PROCESS NAME" -ForegroundColor Yellow
    $name = Read-Host "Enter process name (without .exe)"
    try {
        Stop-Process -Name $name -Force
        Write-Host "✔ Process '$name' terminated." -ForegroundColor Green
    } catch {
        Write-Host "✘ Failed to kill '$name' - $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host "Press any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

function Kill-By-PID {
    Clear-Host
    Show-TaskHeader
    Write-Host "`n🎯 KILL BY PROCESS ID" -ForegroundColor Yellow
    $pidid = Read-Host "Enter PID"
    try {
        Stop-Process -Id $pidid -Force
        Write-Host "✔ PID $pidid terminated." -ForegroundColor Green
    } catch {
        Write-Host "✘ Failed to kill PID $pidid - $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host "Press any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

function Break-Windows {
    Clear-Host
    Show-TaskHeader
    Write-Host "`n☠ BREAK SEQUENCE INITIATED" -ForegroundColor Red
    Write-Host "⚠️  WARNING: THIS WILL KILL CRITICAL SYSTEM PROCESSES!" -ForegroundColor Red
    Write-Host "⚠️  THIS WILL LIKELY CRASH OR BRICK YOUR SYSTEM!" -ForegroundColor Red
    Write-Host "⚠️  ONLY PROCEED IF YOU KNOW WHAT YOU'RE DOING!" -ForegroundColor Red
    $confirm = Read-Host "`nType 'DESTROY' to proceed with system destruction"
    if ($confirm -eq 'DESTROY') {
        Write-Host "`n💀 LAUNCHING DESTRUCTIVE PAYLOAD..." -ForegroundColor Red
        Start-Sleep 1
        Write-Host "3..." -ForegroundColor Red
        Start-Sleep 1
        Write-Host "2..." -ForegroundColor Red
        Start-Sleep 1
        Write-Host "1..." -ForegroundColor Red
        Start-Sleep 1
        Write-Host "`n🔥 EXECUTING CRITICAL SYSTEM TERMINATION..." -ForegroundColor Magenta
        
        $criticalTargets = @(
            "winlogon", "csrss", "wininit", "lsass", "services", "smss", "dwm", "explorer"
        )
        
        Write-Host "💀 TERMINATING CRITICAL SYSTEM PROCESSES:" -ForegroundColor Red
        foreach ($target in $criticalTargets) {
            try {
                Write-Host "🎯 Targeting: $target" -ForegroundColor Yellow
                Stop-Process -Name $target -Force -ErrorAction Continue
                Write-Host "✔ KILLED: $target" -ForegroundColor Red
                Start-Sleep 0.5
            } catch {
                Write-Host "✘ Failed to kill: $target - $($_.Exception.Message)" -ForegroundColor DarkRed
            }
        }
        
        Write-Host "`n💀💀💀 BREAK SEQUENCE COMPLETE 💀💀💀" -ForegroundColor Magenta
        
    } else {
        Write-Host "`nOperation aborted. System spared from destruction." -ForegroundColor Yellow
    }
    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

function Show-TaskAbout {
    Clear-Host
    Show-TaskHeader
    Write-Host "`n📖 ABOUT VOIDKILL" -ForegroundColor Yellow
    Write-Host "VOIDKILL - IS AN ADVANCE TERMINAL BASED TASK MANAGER"
    Write-Host "WARNING: THIS TOOL IS INTENDED FOR EDUCATIONAL PURPOSES ONLY. ;)"
    Write-Host "Press any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

# ================ NETWORK TOOLKIT FUNCTIONS ================

function DOMAINtoIP {
    Clear-Host
    Show-NetHeader
    Write-Host "`n🌐 DOMAIN → IP RESOLVER" -ForegroundColor Cyan
    $domain = Read-Host "Enter domain (e.g., google.com)"
    try {
        $addresses = [System.Net.Dns]::GetHostAddresses($domain)
        Write-Host "`n✔ Resolution successful:" -ForegroundColor Green
        $addresses | ForEach-Object {
            Write-Host "  📍 IP Address: $($_.IPAddressToString)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "✘ Failed to resolve domain: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

function OPENConnections {
    Clear-Host
    Show-NetHeader
    Write-Host "`n🔗 ACTIVE NETWORK CONNECTIONS" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
    try {
        $connections = netstat -ano | Select-String "TCP|UDP"
        if ($connections) {
            $connections | ForEach-Object {
                Write-Host $_.Line -ForegroundColor White
            }
        } else {
            Write-Host "No active connections found." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Failed to retrieve connections." -ForegroundColor Red
    }
    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

function SCANDevices {
    Clear-Host
    Show-NetHeader
    Write-Host "`n🔍 SCANNING NETWORK DEVICES..." -ForegroundColor Cyan
    
    try {
        $localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.PrefixOrigin -eq "Dhcp" })[0].IPAddress
        if (!$localIP) {
            Write-Host "✘ Unable to get local IP address" -ForegroundColor Red
            Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
            [System.Console]::ReadKey($true) | Out-Null
            return
        }
        
        Write-Host "📡 Local IP: $localIP" -ForegroundColor Yellow
        $subnet = ($localIP -split '\.')[0..2] -join '.'
        Write-Host "🎯 Scanning subnet: $subnet.1-254" -ForegroundColor Yellow
        Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
        
        $foundDevices = 0
        1..254 | ForEach-Object {
            $ip = "$subnet.$_"
            if (Test-Connection -ComputerName $ip -Count 1 -Quiet -TimeoutSeconds 1) {
                try {
                    $targethostname = [System.Net.Dns]::GetHostEntry($ip).HostName
                } catch {
                    $targethostname = "Unknown"
                }
                Write-Host "✔ [$ip] - $targethostname" -ForegroundColor Green
                $foundDevices++
            }
        }
        
        if ($foundDevices -eq 0) {
            Write-Host "No devices found on the network." -ForegroundColor Yellow
        } else {
            Write-Host "`n📊 Total devices found: $foundDevices" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "✘ Network scan failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

function IPINFO {
    Clear-Host
    Show-NetHeader
    Write-Host "`n📍 IP GEOLOOKUP TOOL" -ForegroundColor Cyan
    $target = Read-Host "Enter IP address or domain"
    
    try {
        Write-Host "`n🔍 Looking up information for: $target" -ForegroundColor Yellow
        $json = Invoke-RestMethod -Uri "http://ip-api.com/json/$target" -TimeoutSec 10
        
        if ($json.status -eq "success") {
            Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
            Write-Host "📍 IP Address : $($json.query)" -ForegroundColor White
            Write-Host "🌍 Country    : $($json.country)" -ForegroundColor White
            Write-Host "🏙️  Region     : $($json.regionName)" -ForegroundColor White
            Write-Host "🏘️  City       : $($json.city)" -ForegroundColor White
            Write-Host "🏢 ISP        : $($json.isp)" -ForegroundColor White
            Write-Host "🗺️  Coordinates: $($json.lat), $($json.lon)" -ForegroundColor White
            Write-Host "⏰ Timezone   : $($json.timezone)" -ForegroundColor White
            Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
        } else {
            Write-Host "✘ Failed to fetch IP information: $($json.message)" -ForegroundColor Red
        }
    } catch {
        Write-Host "✘ Lookup error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

function PingTarget {
    Clear-Host
    Show-NetHeader
    Write-Host "`n🏓 PING A HOST" -ForegroundColor Cyan

    $targethost = Read-Host "Enter IP address or domain to ping"
    if ([string]::IsNullOrWhiteSpace($targethost)) {
        Write-Host "✘ No host specified!" -ForegroundColor Red
        Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
        [System.Console]::ReadKey($true) | Out-Null
        return
    }

    try {
        Write-Host "`n🎯 Pinging $targethost..." -ForegroundColor Yellow
        Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray

        $pingResults = Test-Connection -ComputerName $targethost -Count 4 -ErrorAction Stop

        if ($pingResults) {
            $pingResults | ForEach-Object {
                $responseTime = if ($_.ResponseTime) { "$($_.ResponseTime)ms" } else { "N/A" }
                $ttl = if ($_.TimeToLive) { $_.TimeToLive } else { "N/A" }
                Write-Host "✔ Reply from $($_.Address): time=$responseTime TTL=$ttl" -ForegroundColor Green
            }

            $totalPings = $pingResults.Count
            $successfulPings = ($pingResults | Where-Object { $_.StatusCode -eq 0 }).Count

            if ($totalPings -gt 0) {
                $lossPercent = [math]::Round((($totalPings - $successfulPings) / $totalPings) * 100, 1)
            } else {
                $lossPercent = 100
            }

            Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
            Write-Host "📊 Ping Statistics:" -ForegroundColor Cyan
            Write-Host "   Packets: Sent = $totalPings, Received = $successfulPings, Lost = $($totalPings - $successfulPings) ($lossPercent% loss)" -ForegroundColor White

            if ($successfulPings -gt 0) {
                $rtts = $pingResults | Where-Object { $_.ResponseTime }
                $avgTime = [math]::Round(($rtts | Measure-Object ResponseTime -Average).Average, 2)
                $minTime = ($rtts | Measure-Object ResponseTime -Minimum).Minimum
                $maxTime = ($rtts | Measure-Object ResponseTime -Maximum).Maximum
                Write-Host "   Approximate round trip times: Minimum = ${minTime}ms, Maximum = ${maxTime}ms, Average = ${avgTime}ms" -ForegroundColor White
            }
        }
    }
    catch {
        Write-Host "⚠️ Test-Connection failed, trying system ping..." -ForegroundColor Yellow
        try {
            $pingOutput = ping $targethost -n 4 2>&1
            $pingOutput | ForEach-Object {
                switch -Regex ($_) {
                    "Reply from" { Write-Host "✔ $_" -ForegroundColor Green }
                    "Request timed out|Destination host unreachable|could not find host" { Write-Host "✘ $_" -ForegroundColor Red }
                    "Packets:|Approximate" { Write-Host "📊 $_" -ForegroundColor Cyan }
                    "Pinging" { Write-Host "🎯 $_" -ForegroundColor Yellow }
                    default { Write-Host $_ -ForegroundColor White }
                }
            }
        } catch {
            Write-Host "✘ All ping methods failed. Check your network connection and target host." -ForegroundColor Red
        }
    }

    Write-Host "`nPress any key to return to menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

# ================ ABOUT FUNCTION ================

function Show-About {
    Clear-Host
    Show-MainHeader
    Write-Host "`n📖 ABOUT VOIDKILL" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host "VOIDKILL - Ultimate Terminal-based System Toolkit" -ForegroundColor White
    Write-Host "Combines advanced task management with network utilities" -ForegroundColor White
    Write-Host ""
    Write-Host "🔥 VOIDKILL Task Manager:" -ForegroundColor Red
    Write-Host "   - Interactive process listing with arrow navigation"
    Write-Host "   - Kill processes by name or PID"
    Write-Host "   - System break sequence (DANGEROUS!)"
    Write-Host ""
    Write-Host "🌐 Network Toolkit:" -ForegroundColor Cyan
    Write-Host "   - Domain to IP resolution"
    Write-Host "   - Active connection monitoring"
    Write-Host "   - LAN device scanning"
    Write-Host "   - IP geolocation lookup"
    Write-Host "   - Network ping utility"
    Write-Host ""
    Write-Host "⚠️  WARNING: This tool is for educational purposes only!"
    Write-Host "Use responsibly and at your own risk."
    Write-Host ""
    Write-Host "author: @Saaransh_Xd"
    Write-Host "youtube: https://www.youtube.com/@Saaransh_Xd"
    Write-Host "github: https://github.com/Saaransh_Dx"

    Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host "`nPress any key to return to main menu..." -ForegroundColor Gray
    [System.Console]::ReadKey($true) | Out-Null
}

# ================ MAIN PROGRAM LOOP ================

function Start-TaskManager {
    while ($true) {
        Draw-TaskMenu
        $key = [System.Console]::ReadKey($true)
        switch ($key.Key) {
            'UpArrow' { $taskSelected = ($taskSelected - 1 + $taskOptions.Length) % $taskOptions.Length }
            'DownArrow' { $taskSelected = ($taskSelected + 1) % $taskOptions.Length }
            'Enter' {
                switch ($taskSelected) {
                    0 { List-Processes }
                    1 { Kill-By-Name }
                    2 { Kill-By-PID }
                    3 { Break-Windows }
                    4 { Show-TaskAbout }
                    5 { return }
                }
            }
            'Escape' { return }
        }
    }
}

function Start-NetworkToolkit {
    while ($true) {
        Draw-NetMenu
        $key = [System.Console]::ReadKey($true)
        switch ($key.Key) {
            'UpArrow' { $netSelected = ($netSelected - 1 + $netOptions.Length) % $netOptions.Length }
            'DownArrow' { $netSelected = ($netSelected + 1) % $netOptions.Length }
            'Enter' {
                switch ($netSelected) {
                    0 { DOMAINtoIP }
                    1 { OPENConnections }
                    2 { SCANDevices }
                    3 { IPINFO }
                    4 { PingTarget }
                    5 { return }
                }
            }
            'Escape' { return }
        }
    }
}

# Main program loop
while ($true) {
    Draw-MainMenu
    $key = [System.Console]::ReadKey($true)
    switch ($key.Key) {
        'UpArrow' { $mainSelected = ($mainSelected - 1 + $mainOptions.Length) % $mainOptions.Length }
        'DownArrow' { $mainSelected = ($mainSelected + 1) % $mainOptions.Length }
        'Enter' {
            switch ($mainSelected) {
                0 { Start-TaskManager }
                1 { Start-NetworkToolkit }
                2 { Show-About }
                3 { 
                    Clear-Host
                    Write-Host "Exiting VOIDKILL..." -ForegroundColor Magenta
                    Clear-Host
                    exit 
                }
            }
        }
        'Escape' { 
            Clear-Host
            Write-Host "Exiting VOIDKILL..." -ForegroundColor Magenta
            Clear-Host
            exit 
        }
    }

}
