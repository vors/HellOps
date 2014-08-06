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

#
# Common functions region.
#

#support only "**bold**" for now, emphasize importent words
function Write-Colorized([string]$markdown) {
    $isInBold = $true
    $markdown -split "\*\*" | % {
            $isInBold = -not $isInBold
            if ($isInBold) {
                Write-Host -BackgroundColor Black -ForegroundColor Yellow -NoNewline $_
            } else {
                Write-Host -BackgroundColor Black -ForegroundColor White -NoNewline $_
            }
        }
    Write-Host "" # new line
}

function Write-LineColorized([string]$markdown) {
    $wrappedMarkdown = ("`n" + $markdown + "`n")
    $isInBold = $true
    $wrappedMarkdown -split "\*\*" | % {
            $isInBold = -not $isInBold
            if ($isInBold) {
                Write-Host -BackgroundColor Black -ForegroundColor Yellow -NoNewline $_
            } else {
                Write-Host -BackgroundColor Black -ForegroundColor White -NoNewline $_
            }
        }
    Write-Host "" # new line
}

#
# End of Common functions region.
#

#TODO: private
function Start-NextLevel {
    
    Begin {}
    
	Process {
		
        if ($global:currentLevelId -ge $allNormalLevels.Count) {
            Write-Host -ForegroundColor Green "That was the last level."
        } else {
            if ($global:currentLevelId -gt 0)
            {
                pause
            }

            #go back to the root game dir in case the user wandered off, so that level setup always begins in a known location
            cd $gameRootDir
            
            #we use 1-based level numeration.
            $global:currentLevelId = $global:currentLevelId + 1        
            $file = $allNormalLevels[$global:currentLevelId - 1]
            if (Test-Path $file) {
                Write-Host 
			    Write-Host -ForegroundColor Green -BackgroundColor Black "Congratulations! You've advanced to the next level!"
                Write-Host 
                #TODO: track some sort of point system as the level progresses, and spit out the level score here

                . $file
                Start-Level
            } else {

                <# 
                Because we're asking the player to learn powershell to solve puzzles, there's every chance they may do something that breaks our ability to move on.
                Like removing files, or renaming them (no I don't know why they would do that, but they're users, they do lots of silly things, stop asking questions).
                IF that happens in a way we can detect here, then we point the finger at them. And laugh. 
                
                TODO: We should really find a way to let the users ping back to us when they hit any of these little hidden tributes, 
                so that they can let us know that they know, and we can let them know that we know that they know.
                There should be much knowing.
                #>

                Write-Host
                Write-Host -ForegroundColor Red -BackgroundColor Black "What have you done?! We can't find the next level!"
                Write-Host
                Write-Host -ForegroundColor Red -BackgroundColor Black "Well, we're pretty sure this is your fault."
                Write-Host -ForegroundColor Red -BackgroundColor Black "You can either restore the weave of fate (undo whatever you did), or persist in the doomed world you have created."
                Write-Host

                <#
                TODO: Some sort of save system would allow a user to pick up where they left off, but would also require that each level completely own the setup for itself.
                That's not what we've got going on in the file lock level though, just for a good sense of continuity (the file gets created at the very beginning).
                We could fix that, ask them to run another ls at the start of that level, and then laugh at ourselves in the narration text about how inconsistient it was.
                #>

            }

        }
    }

    End {}
}

# while itterating for development, it's handy to make sure that any jobs started by levels that use them get stopped
get-job | stop-job

$global:gameRootDir = Join-Path $env:temp "HelloPS" #([System.Guid]::NewGuid())
if ((Test-Path $gameRootDir) -eq $false) {
    mkdir $gameRootDir
}

$global:allNormalLevels = @(
    "$PSScriptRoot\LevelFirst.ps1",
	"$PSScriptRoot\LevelString.ps1",
    "$PSScriptRoot\LevelVar.ps1",
	"$PSScriptRoot\LevelPipe.ps1",
    "$PSScriptRoot\LevelMan.ps1"
    "$PsScriptRoot\LevelFileLock.ps1",
    "$PsScriptRoot\LevelFinal.ps1"
    # TODO: include variation of LevelTextViewIds.ps1 to the story
)


$global:allSecretLevels = @(
    "$PSScriptRoot\CowLevel.ps1",
    "$PsScriptRoot\CafeOfBrokenDreams.ps1",
    "$PsScriptRoot\TombOfTheNamelessOne.ps1"
)
		

$global:currentLevelId = 0
Start-NextLevel
