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
    $global:shoutedTooSoon = $false
    $global:shoutedTheRightWayTooSoon = $false

    Write-Colorized @"
Ok, so the first rule of "locked in the server room by your nemesis" club is: don't trust your nemesis.
He claims that no one will hear you if you shout for help. You should probably try anyway.

(Try shouting for help by doing something that will output "Help!" to the console)

"@

    $dir = Join-Path $env:temp ([System.Guid]::NewGuid())

	function global:step1() { 
        $lastCommand = (Get-History -Count 1).CommandLine

        if ($lastCommand -eq '"Help!".ToUpper()') {
            $global:shoutedTheRightWayTooSoon = $true
            Write-LineColorized @"
Ok, look... it's POSSIBLE that we're really operating on the same wavelength here or that you're just amazingly gifted.

It's more likely that you're reading ahead.
Cut it out.
We've got a job to do, and no one likes a teacher's pet.
"@
        } else {
            if ($lastCommand -ceq '"Help!"') {
                Write-LineColorized @"
Excellent! Hmm, that didn't seem to do any good though; the door didn't open. 
But you weren't really shouting there were you? One more time, with feeling!
"@
                
                if ($global:shoutedTheRightWayTooSoon) {
                    Write-LineColorized @"
(Yes, NOW you can do what you tried to do earlier. You're on notice though. I'm watching you.)
"@
                } elseif ($global:shoutedTooSoon) {
                    Write-LineColorized @"
Also, to answer the question you're probably only asking if you're REALLY paying attention: 
Yes, we know you tried to do this earlier.
No, you can't get partial credit for trying to skip ahead. We've got a lesson plan here, and you need to stick to it!

Besides, we didn't like the way you did it before. Do it again. The right way.
"@
                }

                function global:verify() {
                    step2
                }
                $global:cluelessCount = 0
            } else {
                if ($lastCommand -eq '"Help!"') {
                    Write-LineColorized "You should probably review the basic rules of capitolization for the english language..."
                    if ($lastCommand -ceq '"HELP!"') {
                        $global:shoutedTooSoon = $true
                    }
                } else {
                    $global:cluelessCount++
                    switch($global:cluelessCount)
                    {
                        1 {Write-LineColorized "what's that?"}
                        2 {Write-LineColorized "Someone wasn't paying attention in class..."}
                        3 {Write-LineColorized "To output string in PowerShell, you have to surround it with quotes"}
                        4 {Write-LineColorized "Did you try **""Help!""** already ?"}
                        5 {Write-LineColorized "Look, when we make words yellow, that's a clue! Try **""Help!""**!"}
                        default {Write-LineColorized "SERIOUSLY... try running the command **""Help!""**!"}
                    }
                }
            }
        }
    }
	
	function global:step2() {
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq '"Help!".ToUpper()') {
            
            # TODO: is this a specific difference between linux shell and powershell? Or should we tell them the full format of <object>.<methodname>()?
            Write-LineColorized "Good job! In PowerShell you call functions on objects by using parenthesis at the end of the function name." 
            Write-LineColorized "You don't need to use parenthesis however when obtaining value of an object's property." 
            Write-LineColorized "With this in mind, try to get length of the 'Help!' string"

            if ($global:shoutedTheRightWayTooSoon) {
                    Write-LineColorized "(Yes, I'm STILL watching you.)"
            }

            function global:verify() {
                step3
            
            }
            $global:cluelessCount = 0

        } elseif ($lastcommand -ceq '"HELP!"') {
            
            if($global:shoutedProperlyOnceAlready -eq $false)
            {
                # If it's the first time you've tried this, we reset your count as we bump you over to the "you've got the right idea" track.
                # This keeps the hints from confusing you, because they can then focus on the how instead of the what.
                $global:cluelessCount = 0            
            }
            $global:shoutedProperlyOnceAlready = $true;
            
            if ($global:shoutedTooSoon) {
                Write-LineColorized "Nice try (again)! But that's not how programmers do it, which is why we didn't like it last time!"
            } else {
                Write-LineColorized "Nice try! But that's not how programmers do it..."
            }
		} else {
            $global:cluelessCount++
            if($global:shoutedProperlyOnceAlready) {
                
                # this track is for people who have tried to go all caps
                switch($global:cluelessCount)
                {
                   1 {Write-LineColorized 'Run **"Help!" | Get-Member** to get available functions for String'}
			       2 {Write-LineColorized 'The function you want to use is called **"ToUpper"**... just call it!'}
                   3 {Write-LineColorized 'Pardon me, but the gentleman at the bar sent this over: **"Help!".ToUpper()**'}
                   default {Write-LineColorized 'Seriously, just run **"Help!".ToUpper()** so that we can move on!'}
                }

            } else {
                # this track is for people who have NOT tried to go all caps the simple way yet
                switch($global:cluelessCount)
                {
                   1 {Write-LineColorized "Are you telling me you never had an AOL account?"}
                   2 {Write-LineColorized "Seriously, did you NEVER have anyone ask you to STOP SHOUTING in IRC?"}
                   3 {Write-LineColorized 'Run **"Help!" | Get-Member** to get available functions for String'}
			       4 {Write-LineColorized 'The function you want to use is called **"ToUpper"**... just call it!'}
                   5 {Write-LineColorized 'Pardon me, but the gentleman at the bar sent this over: **"Help!".ToUpper()**'}
                   default {Write-LineColorized 'Seriously, just run **"Help!".ToUpper()** so that we can move on!'}
                }
            }
        }
    }
	
    function global:step3() {
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq '"Help!".Length') {
            
			Write-Colorized @"

Nice work! 

Just don't ask us to clarify how exactly calling out the length of the string "Help!" applies to getting out of this room ASAP.
Instead relish the feeling of confidence associated with knowing that you can now access both properties AND methods on objects. 

That's a REALLY important thing in Powershell, because the fact that everything is an object is what makes Powershell so 
fantastically powerful!

So yes, definately focus on that feeling of confidence, because focusing on it MIGHT help you to ignore 
the feeling of building pressure in your bladder. 
"@
            $global:cluelessCount = 0
            # FINISH !!!
            Start-NextLevel
        } elseif ($lastcommand -eq '5') {
            Write-LineColorized "Nice try! But that's not how programmers do it..."
		} else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
               1 {Write-LineColorized "Hmm? We want to to get the length of the string ""Help!"""}
               2 {Write-LineColorized 'Run **"Help!" | Get-Member** to get members of the String object if you don''t remember them' }
			   3 {Write-LineColorized 'The property you want to use is called **"Length"**... just get it!'}
               4 {Write-LineColorized 'Try running the command **"Help!".Length**!'}
               default {Write-LineColorized 'Stop wasting time, have you forgotten that there''s no toilet in here!? Run the command **"Help!".Length**!'}
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
