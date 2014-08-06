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

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Import-Module $scriptPath\Utilities.psm1

# Removes all spaces from the string
function RemoveSpaces() {
    param(
        [String]$text
    )
    
    $text.Replace(' ', '')
}

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
Do you think there might be some processes which you might utilize to get out of here? Check them out!
"@

    $dir = Join-Path $env:temp ([System.Guid]::NewGuid())

	function global:step1() { 
        $lastCommand = (Get-History -Count 1).CommandLine
        if ($lastCommand -eq 'Get-Process') {
            Write-Colorized "Cool! I don't see anything interesting there though, do you?" 
            Write-Colorized "Anyway, if you would ever be looking for some specific process, you can list all it's instances using Where-Object!"
            Write-Colorized "To give it a try, list only instances of PowerShell processes. Use piping..." 
            function global:verify() {
                step2
            }
            $global:cluelessCount = 0
        } else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
                1 {}
				2 {Write-Colorized 'It''s just single cmdlet call...'}
                3 {Write-Colorized 'Did you try **Get-Process** already ?'}
                default {Write-Colorized 'Run the command **Get-Process**!'}
            }
        }
    }
	
	function global:step2() {
        $lastCommand = (Get-History -Count 1).CommandLine
		$lastCommand = RemoveSpaces($lastCommand)
		$output1 = RemoveSpaces('Get-Process | Where-Object {$_.Name -Match "PowerShell"}')
		$output2 = RemoveSpaces('Get-Process | ? {$_.Name -Match "PowerShell"}')
		$output3 = RemoveSpaces('Get-Process | ? {$_.Name -eq "PowerShell"}')
		$output4 = RemoveSpaces('Get-Process | Where-Object {$_.Name -eq "PowerShell"}')
		
        if ($lastCommand -eq $output1 -or $lastCommand -eq $output2 -or $lastCommand -eq $output3 -or $lastCommand -eq $output4) {
            Write-Colorized "Good job! As I said, it might not be what you need right now, but don't forget what you just learned."
            Write-Colorized "You never know when it will come handy... ;)"
			$global:cluelessCount = 0
			Start-NextLevel
		} else {
            $global:cluelessCount++
            switch($global:cluelessCount)
            {
               1 {Write-Colorized 'Keep trying...'}
               2 {Write-Colorized 'Pipe **Get-Process** to **Where-Object** and get only those processes which name matches "Powershell"' }
			   3 {Write-Colorized 'Use $_Name -Match "PowerShell '}
               default {Write-Colorized 'Run the command **Get-Process | Where-Object {$_.Name -Match "PowerShell"}**!'}
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
