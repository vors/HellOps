# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

function global:Start-Level() {
    function SetUp() {
        function global:verify() {}
        function global:prompt() {
            . $function:verify
            Write-Host ">" -nonewline 
        }
    }

    # TODO: detect any early messing with the file (no getting sneaky!), stomp desired values back in, and narrate a bit about
    # the twerp having an agent in the system that's caught on to you now.

    SetUp
    $global:cluelessCount = 0;

    $global:permissionsModified = $false
    $global:permissionsModifiedCorrectly = $false
    $global:startTime = Get-Date

    Write-Colorized @"
Ok, it's time to stop being polite... and start getting real. 

That little twerp was having a full on bond-villan-esque moment.
He probably told you EXACTLY what you need to know to get out of here.

Time to find that permissions file, and upgrade yourself from zero to hero!
Well, maybe hero is stretching it. How about to **Adminsitrator** at least?
"@
    $job = Start-Job -Name "Rinzler" -ScriptBlock {
    param($fileToLock)
    $file = [System.io.File]::Open($fileToLock, 'Open', 'Read', 'Read')
    $reader = New-Object System.IO.StreamReader($file)
    $text = $reader.ReadToEnd()
    while($true) {Sleep -Seconds 10}
    $reader.Close()
    } -ArgumentList $xmlFilePath
    

    function global:step1() { 
        [xml]$document = Get-Content -Path $global:xmlFilePath
        [xml]$originalContents = $global:originalXmlfileContents

        if( $document.InnerXml -ne $originalContents.InnerXml) {
            $global:permissionsModified = $true
        } else {
            $global:permissionsModified = $false
        }

        foreach($user in $document.Users.User)
        {
            if($user.Name -eq $env:USERNAME -and $user.role -eq "Administrator")
            {
                $global:permissionsModifiedCorrectly = $true
            }
        }

        if($global:permissionsModified)
        {

            if ($global:permissionsModifiedCorrectly) {

                Write-Colorized @"
Wow, nice work, you might get out of here in dry pants after all!

Of course, all you've done now is defeat the dragon guarding the wall... 
You've still got to figure out how to get a pigeon to carry a message for you...

Tell me, how do you feel about typing your twitter credentials into 
a powershell script you just downloaded from the internet?
I'm just kidding. We haven't written that level yet! 

You can consider yourself VICTORIOUS... for now.

Well... unless you didn't find any of the secret levels. You found those right? No? Oh.
Then I guess you'd probably be only PARTIALLY victorious. But hey, I'm sure you're happy with that... right?
Hmm... you know what, let's pretend I didn't say that. Because we TOTALLY didn't write ANY secret levels.

"@

                Start-NextLevel
            } else {
                Write-LineColorized @"
Well, you've modified the file, but not in the desired way...
If you've lost the original XML and need to put it back, run **ResetBasePermissionsXml**
"@
            }
        } else {
            if ((Get-Date).subtract($global:startTime).TotalSeconds -gt 10 -and ((Get-History -Count 1).CommandLine -ne "GetNextHint") ) {
                Write-LineColorized "If you're stumped, use **GetNextHint** to get a hint!"
                $global:startTime = Get-Date
            }
        }


    }

    function global:verify() {
        step1
    }

    $global:hints = @(
    "You're going to have to know about **Get-Content** and **Set-Content**...",
    "You'll need to learn about the **-Replace**  operator (**man about_Comparison_Operators**)",
    "AND you'll need to learn about **Get-Job** and **Stop-Job**",
    "Powershell is actually SO powerful that you can complete this level with a single line once you've become a master.",
    "just run this: **get-job | stop-job ; sc .\permissions.xml ((gc .\permissions.xml) -replace 'luser', 'Administrator')**"
    )

    function global:GetNextHint() {
        if($global:cluelessCount -lt $global:hints.Count-1) {
            Write-LineColorized $global:hints[$global:cluelessCount]
            $global:cluelessCount++        
        } else {
            $input = Read-Host -Prompt "This will show you the final answer, are you sure? [y/n]: "
            if($input -eq "y" -or $input -eq "yes") {
                Write-LineColorized $global:hints[$global:cluelessCount]
            }
        }
    }

    function global:ResetBasePermissionsXml
    {
        sc $global:xmlFilePath $global:originalXmlfileContents
    }

}
