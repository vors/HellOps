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
    $global:cluelessCount = 0

    Write-Colorized @"
You decide suddenly that you'd rather be dead than be known as the guy who 
confused the server room with the bathroom. If you're going to get out of here before 
damaging any hardware (or your reputation), you need to send a message!
That means you're going to have to do something ALMOST as embarassing as having an accident in here.

You're going to have to read the manual.

You AGAIN silently thank Microsoft for keeping things familiar... and run **man**
"@

    function global:step2() { 
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq "`"1a51fd256574330c98ca4b86488bc2a2fa21170b`"") {

            Write-LineColorized @"
Yup, that's the one! You now know how to find out all there is to know about anything you want to know about!

I think a wise man once said that "knowing is at least half the battle"... Or was it "know thyself"?

Whatever. Remember **man** (really an alias for **Get-Help**) in the desperate minutes to come. You'll need it.
"@

            $global:cluelessCount = 0
            function global:verify() {}
            Start-NextLevel
        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
                1 {}
                2 {}
                3 {Write-LineColorized "Are you sure you read the full manual?"}
                default {Write-LineColorized "Try running the command **man -full Get-Cake** and use it output to find sha1!"}
            }
        }
    }
    
    function global:step1() { 
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq "man Get-Cake") {
            Write-LineColorized "Sweet. Give me a sha1 from the help." 
            function global:verify() {
                step2
            }
            $global:cluelessCount = 0
        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
                1 {}
                2 {Write-LineColorized "Do you know what **Get-Cake** does?"}
                3 {Write-LineColorized "Can you look it up in the manual?"}
                4 {}
                default {Write-LineColorized "Try running the command **man Get-Cake**!"}
            }
        }
    }

    function global:step0() { 
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq "man") {
            function global:Get-Cake() {
                <#
                .SYNOPSIS
                Give you a cake.

                .DESCRIPTION
                Once you done with all these tasks, function will give you a cake. But now it doesn't do that.
                We also will invite all you friends to our small cake-party.

                .NOTES
                The cake is a lie. Use 1a51fd256574330c98ca4b86488bc2a2fa21170b to escape.
                #>

            }
            Write-LineColorized "Now that you know **man** works, you wonder what it would tell you about the **Get-Cake** function."
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
                default {Write-LineColorized "Try running the command **man**!"}
            }
        }
    }

    function global:verify() {
        step0
    }

}

