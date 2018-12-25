$curip = 0.0.0.0
$oldip = 0.0.0.0
$logfilename = "log.txt"

# Ask for hot IP
Write-Host "Do you know the current hot IP? Enter hot ip (example: .72), or leave blank."
$hotip = Read-Host -Prompt "Hot ip: "

if ($hotip)
{
    Write-Host "Set to ",$hotip
}
else
{
    Write-Host "Not checking for hot IP."
}

# Ask for logging
$tolog = Read-Host -Prompt "Log to file? Input anything for yes, or leave blank for no."

if ($tolog)
{
    Write-Host "Writing to logfile: ",$logfilename
}
else
{
    Write-Host "Not keeping a log for this session."
}

$starttime = (Get-Date).DateTime
Write-Host $starttime,"Program start."

if ($tolog)
{
    # We have started a new session, write this to log if desired to keep a log file
    Out-File -FilePath $logfilename -InputObject "--------------" -Append -Force
    Out-File -FilePath $logfilename -InputObject $starttime,"New session:" -Append -Force
    
    if ($hotip)
    {
        Out-File -FilePath $logfilename -InputObject $starttime,"Hot ip is set to: ",$hotip -Append -Force
    }
}

while($true)
{
    sleep 1
    $thetime = (Get-Date).DateTime
    
    # We know that D2 servers are connected to remoteport 4000
    # So we can just check which program is connected to this and get IP from there
    $curip = Get-NetTCPConnection -AppliedSetting internet -State established -Remoteport 4000 -ErrorAction SilentlyContinue | select -expandproperty remoteaddress | Out-String
    
    if ($curip)
    {
        if ($curip -ne $oldip)
        {
            write-host $thetime," IP CHANGED:  ",$curip
            $oldip = $curip

            if ($tolog)
            {
                Out-File -FilePath $logfilename -InputObject $thetime,$curip -Append
            }

            if ($hotip)
            {
                    if ($curip -match $hotip)
                    {
                        Write-Host "!!! HOT IP !!!" -foreground "Green"
                        
                        if ($tolog)
                        {
                            Out-File -FilePath $logfilename -InputObject "HOT IP!" -Append -Force
                        }
                    }
             }
        }
    }
    else
    {
        $oldip = $curip
    }
}
