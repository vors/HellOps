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
    
    function Write-LevelStatement() {
        Write-Host -ForegroundColor Cyan "Find all TextView's ids and sort them alphabetically."
        Write-Host -ForegroundColor Cyan "To check your answer, pipe list of ids to Set-Answer: '... | Set-Answer'."
    }

    function Clone-Repo() {
        Write-Host -ForegroundColor Yellow "Clonning sample repo facebook-android-sdk for you."
        $path = ".\facebook-android-sdk"
        if (Test-Path $path) {
            Write-Host -ForegroundColor Red "Cannot setup level for you: directory $path already exists."
            Write-Host -ForegroundColor Yellow "Please, change working directory or remove $path"
            return $false
        }
        git clone https://github.com/facebook/facebook-android-sdk.git
        Push-Location .\facebook-android-sdk
        git checkout 13af7a53e3201a139f446bb253bde71dad2e5d2d
        Pop-Location    
        return $true
    }

    if (Clone-Repo) {
        Write-LevelStatement
    }
}

function global:Set-Answer {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [string]
        $id
    )

    Begin {
        $list = @()
        $answer = @(
            "@+id/com_facebook_picker_title",
            "@+id/com_facebook_picker_list_section_header",
            "@+id/com_facebook_picker_title",
            "@+id/com_facebook_picker_title",
            "@+id/picker_subtitle",
            "@+id/com_facebook_tooltip_bubble_view_text_body",
            "@+id/com_facebook_usersettingsfragment_profile_name",
            "@+id/resultsTextView",
            "@+id/greeting",
            "@+id/resultsTextView",
            "@+id/content_title",
            "@+id/friend_action_date",
            "@+id/friend_game_result",
            "@+id/text_rock",
            "@+id/text_paper",
            "@+id/text_scissors",
            "@+id/shoot",
            "@+id/who_won",
            "@+id/stats",
            "@+id/text1",
            "@+id/text2",
            "@+id/announce_text",
            "@+id/message_text",
            "@+id/skip_login_button",
            "@+id/profileUserName",
            "@+id/slotUserName"
        )
    }

    Process {
        $list += $id; 
    }

    End {
        $diff = Compare-Object $list $answer
        if ($diff) {
            Out-Fail($diff)
        } else {
            Out-Success
        }
    }
}