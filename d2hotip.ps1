$curip = 0.0.0.0
$oldip = 0.0.0.0
$logfilename = "log.txt"

Write-Host "---------"
Write-Host "Do you know the current hot IP? Enter hot ip (example: .72), or leave blank."
$hotip = Read-Host -Prompt "Hot ip: "

if ($hotip) {

    Write-Host "Set to ",$hotip
}
else {

    Write-Host "Not checking for hot IP."
}
Write-Host "---------"
$tolog = Read-Host -Prompt "Log to file? Input anything for yes, or leave blank for no."

if ($tolog) {

    Write-Host "Writing to logfile: ",$logfilename
}
else {

    Write-Host "Not keeping a log for this session."
}
Write-Host "---------"
$starttime = (Get-Date).DateTime
Write-Host $starttime,"Program start."

if ($tolog) {

    Out-File -FilePath $logfilename -InputObject "--------------" -Append
    Out-File -FilePath $logfilename -InputObject $starttime,"New session:" -Append
    if ($hotip) {
        Out-File -FilePath $logfilename -InputObject $starttime,"Hot ip is set to: ",$hotip -Append
    }
}

while($true){

    sleep 1
    $thetime = (Get-Date).DateTime
    $curip = Get-NetTCPConnection -AppliedSetting internet -State established -Remoteport 4000 -ErrorAction SilentlyContinue | select -expandproperty remoteaddress | Out-String
    
    if ($curip){

        if ($curip -ne $oldip) {

            write-host $thetime," IP CHANGED:  ",$curip
            $oldip = $curip

            if ($tolog) {

                Out-File -FilePath $logfilename -InputObject $thetime,$curip -Append
            }

            if ($hotip) {

                    if ($curip -match $hotip) {

                        Write-Host "!!! HOT IP !!!" -foreground "Green"
                        
                        if ($tolog) {

                            Out-File -FilePath $logfilename -InputObject "HOT IP!" -Append
                        }
                    }
             }
        }
    }
    else {
        $oldip = $curip
    }
}
        
