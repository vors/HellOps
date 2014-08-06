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

    SetUp
    $global:cluelessCount = 0;
    
    Write-Colorized @"
Ok, so maybe your nemesis was right about no one being able to hear you in there. 
That is NOT a reason to panic! 
Your nemesis made a whole series of independent claims, and you've only tested one of them!

Let's see if the kid was telling the truth about the booked work schedule next. Then we can panic.

Oh, look, somobody left a **`$schedule** variable lying around in here! Just for you!
"@

    $global:schedule = new-object PsObject -Property ([ordered]@{
        Name = (new-object system.globalization.datetimeformatinfo).MonthNames[(Get-Date).Month-1] + " Ops Schedule"
        Details = new-object PsObject -Property ([ordered]@{
            John = "scheduled for vacation"
            Cameron = "scheduled for vacation"
            Bartholomew = "scheduled for vacation"
            Max = "scheduled for vacation"
            Isaac = "scheduled for vacation"
        })
<#
    $global:schedule = new-object PsObject -Property ([ordered]@{
        Name = (new-object system.globalization.datetimeformatinfo).MonthNames[(Get-Date).Month-1] + " Ops Schedule"
        Details = new-object PsObject -Property ([ordered]@{
            John = new-object PsObject -Property ([ordered]@{status ="on vacation"})
            Cameron = new-object PsObject -Property ([ordered]@{status ="on vacation"})
            Bartholomew = new-object PsObject -Property ([ordered]@{status ="on vacation"})
            Max = new-object PsObject -Property ([ordered]@{status ="on vacation"})
            Isaac = new-object PsObject -Property ([ordered]@{status ="on vacation"})
        })

@"
John 
    scheduled for vacation

Cameron 
    scheduled for vacation

Bartholomew 
    scheduled for vacation

Max 
    scheduled for vacation

Isaac 
    scheduled for vacation
"@  
#>

        # long line, doesn't fit in default output, so Clue explain what to do.
        Clue = "Try `$schedule.Details"
    })

    function global:step2() {
        $success = $false
        $schedule.Details | Get-Member -MemberType NoteProperty  | % { if ($_.Definition -like "*$env:COMPUTERNAME*") {$success = $true} }

        if ($success) {
            # TODO: best to spit out the schedule again?
            Write-Host ($schedule.Details | Format-Table | Out-String)



            Write-LineColorized @"
Great! 
Now someone will notice that one of those guys on vacation needs to come back in here!

Oh, wait... that's not any better... 
I mean, sure, you're not going to DIE in here now.
But it'll still be tommorow at the earliest before anyone notices the changed schedule and starts trying to get someone in here.

Your bladder is NOT going to wait that long!
"@

            $global:schedule = $null
            $global:cluelessCount = 0
            Start-NextLevel

        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
                1 {Write-LineColorized "You'll probably have to put the name of this machine ($env:COMPUTERNAME) in there to get anyone to come in here though..."}
                2 {Write-LineColorized "Why don't you try to set the value of **`$schedule.Details.John**?"}
                3 {Write-LineColorized "Why don't you schedule John to unplug this machine IMMEDIATELY?"}
                4 {}
                default {Write-LineColorized "SERIOUSLY... try running the command **`$schedule.Details.John = ""unplug $env:COMPUTERNAME IMMEDIATELY""**!"}
            }
        }
    } 

    function global:step1() { 
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq "`$schedule.Details") {

            Write-LineColorized @"
Ok. So no one is scheduled to come in here this month. Hmm. I bet you can change that.
"@

            function global:verify() {
                step2
            }
            $global:cluelessCount = 0
        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
                1 {}
                2 {}
                3 {}
                4 {Write-LineColorized "Did you see a **`$schedule.Clue**?"}
                default {Write-LineColorized "SERIOUSLY... try running the command **`$schedule.Details**!"}
            }
        }
    }

    function global:step0() { 
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq "`$schedule") {
            Write-LineColorized @"
Well, it looks like John and Cameron are both on vacation, but they're not the only two guys who do stuff in this room.

It's a shame that **`$schedule.Details** is too long to fit on the screen with the rest of the information...
You can't see the work detail for any of the other Ops guys the way it got cut off!
"@
            function global:verify() {
                step1
            }
            $global:cluelessCount = 0
        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
                1 {}
                2 {}
                3 {}
                default {Write-LineColorized "Try running the command **`$schedule**!"}
            }
        }
    }

    function global:verify() {
        step0
    }

}

