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
        Clear-Host
        Sleep -Seconds 1
        function global:verify() {}
        function global:prompt() {
            . $function:verify
            Write-Host ">" -nonewline 
        }
    }

    function Create-ReadmeFile() {
        $readmePath = Join-Path $gameRootDir "readme"
        $readmeMessage = @"
I'm not sure how long it will take you to find this message. I'm guessing you won't see it until 
"@ + (Get-Date).DayOfWeek + @"
, 
since my initial impression from the last week of working with you hasn't left me with an abundance 
of confidence in your ability to adapt to new situations, but it doesn't really matter. 
There's nothing you can do at this point. In that server room, no one can hear you scream.

I've ensured that no one is going to open that door until it's far too late to help you; there's no work 
scheduled to require anyone to enter that room for the rest of the month, and I've discouraged random 
wandering in that area by leaving a stack of old takeout boxes under one of the floor pannels in the hallway!

The only way you could possibly escape would be to send a message from the machine you're using to read this, 
and since all the servers have been upgraded to Windows Server 2012 R2, and you never bothered to learn powershell, 
the chances of you figuring out how to modify the permissions list for the firewall to allow you to send a message 
out are about on par with your chances of finding a restroom in there. I think it's fair to say that 
there's going to be quite a surprise in store for the guys who are scheduled to do the router upgrade in 
"@ + (new-object system.globalization.datetimeformatinfo).MonthNames[(Get-Date).AddMonths(1).Month-1] + @"
!

I'd like to say it was fun working with you, but it's not nice to lie to the condemned. 
 
That sweet parking space is mine sucker!
"@
        Set-Content -Path $readmePath -Value $readmeMessage
    }

    $global:xmlFilePath = Join-Path $gameRootDir "permissions.xml"

    function Create-XmlPermissionsFile($filePath) {
        
        $global:originalXmlfileContents = @"
<?xml version="1.0" encoding="utf-16"?>
<Users>
  <user>
    <name>Hiro.Protagonist</name>
    <role>Administrator</role>
  </user>
  <user>
    <name>Bob.Howward</name>
    <role>Administrator</role>
  </user>
  <user>
    <name>Zero.Cool</name>
    <role>Administrator</role>
  </user>
  <user>
    <name>
"@ + $env:USERNAME + @"
</name>
    <role>luser</role>
  </user>
</Users>
"@
        Set-Content -Path $filePath -Value $global:originalXmlfileContents
    }
    
    
    SetUp
    $global:cluelessCount = 0;
    Create-ReadmeFile
    Create-XmlPermissionsFile -filePath $xmlFilePath

    Write-Colorized @"
You are a linux sysadmin. 

You wake up to find yourself locked in the server room, dangerously low on mountain dew. 
No one hears your (increasingly panicked) cries for help. Your phone gets no signal, and the wifi is offline. 
You realize quickly that you'll have to send a message from the terminal in the corner if you want to get out of here.
You also realize you'd better hurry, because there's a pile of empty mountain dew cans next to you, 
and no restroom in the server room. 

You sit down at the terminal to find everything has changed. You're staring at a fresh powershell prompt. 
This can't be right! You upgraded everything to Ubuntu 10.04.01 yourself last weekend! 

Saying a silent thanks to Microsoft for keeping some things familiar, you run **ls** to find out 
what you've got to work with...

"@

    $dir = Join-Path $env:temp ([System.Guid]::NewGuid())

    function global:step2() {
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq "cat readme" -or $lastCommand -eq "cat .\readme") {
            
            $flavorText = [String]::Empty
            if ($global:cluelessCount -gt 2)
            {
                $flavorText = @"

Before you let the whole "2 for 2" thing go to your head: you'd have been here sooner if you paid attention.
Yes, you're here now, and that's what really matters, but honestly you lot! Try to keep up!

Now where were we... Oh yes!

"@
            }
            else {
            $flavorText = @"

I'd also like to take this oportunity to point out that you're really flying through this thing!
Seriously! Maybe we're putting in too many hints? Or maybe you're just that good!

Anyway, where were we... Oh yes!

"@
            }

            Write-Colorized (@"
You're 2 for 2! **cat** is also just an alias in Powershell. It's mapped to **Get-Content**. 

"@ + $flavorText + @"

The taunting message you've discovered is obviously from the junior sysadmin who started last week.
It eliminates any doubt that you were trapped here accidentially.

Looks like it's time to dig in and learn some new tricks!
Unless you like the idea of being trapped here until you wet yourself and then die of dehydration...

"@) 
            
            # TODO: link to Get-Content docs online
            
            $global:cluelessCount = 0
            # FINISH !!!
            Start-NextLevel
        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
               1 {Write-LineColorized "that's not what I said to do..."}
               2 {Write-LineColorized "Someone seems to have left you a note... why don't you look in the **readme**"}
               3 {Write-LineColorized "Are you this difficult all the time? **readme** is begging for your attention!"}
               default {Write-LineColorized "SERIOUSLY... try running the command **cat readme**!"}
            }
        }
    } 

    function global:step1() { 
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq "ls") {
            Write-Colorized @"
Good job! You should probably know that **ls** in Powershell is actually just an Alias for **Get-ChildItem**.
There are lots of other Aliases in powershell. You can use **Get-Alias** or **gal** to list them.

Oh, look at that... I wonder what's in the **readme** file... maybe you should **cat** it?

"@ 
            
            # TODO: link to Get-ChildItem docs online
            # TODO: link to Get-Alias docs online
            
            function global:verify() {
                step2
            }
            $global:cluelessCount = 0
        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
                1 {}
                2 {Write-LineColorized "Someone wasn't paying attention..."}
                3 {Write-LineColorized "Or maybe you're using a monochrome monitor."}
                4 {Write-LineColorized "Did you try **ls** let?"}
                5 {Write-LineColorized "Look, when we make words yellow, that's a clue! Try **ls**!"}
                default {Write-LineColorized "SERIOUSLY... try running the command **ls**!"}
            }
        }
    }

    function global:verify() {
        step1
    }

}


function Get-Character() {
    function New-Character() {
        $ht = @{
            Inventory = @()
            Name = 'Admin'
        }
        new-object PsObject -Property $ht
    } 

}
