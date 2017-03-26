# Loop through the groups, if there is a meetup within next 24 hours then post it!
# Observed that the meetup group photo is squished to square shape in Teams. Not sure there is much we can do about that!

$TeamMeetups = (@{ 'TeamName' = 'MSTeamExperiments.TestChannel1'; 
    'Webhook' = 'https://outlook.office.com/webhook/<your-secure-string-here>';
    'MeetupGroups' = @("MelbourneAzure","devops-melbourne","Melbourne-Powershell-Meetup","Infrastructure-Coders","Melbourne-Serverless-Meetup-Group","Melbourne-Microsoft-Cloud-and-Datacenter-Meetup", #devops
        "Melbourne-ALT-NET","Melbourne-Microservices","Chatbots-Messaging-and-AI-Melbourne","Melbourne-Web-Developers","Melbourne-TechTalk", # programming
        "TestEngineeringAlliance","Melbourne-Software-Testing-Meetup-Group","Melbourne-Software-Testing-Meetup", # testing
        "scrum-12","Enterprise-Innovation-Meetup","Limited-WIP-Society","AgileCoach","Australia-Delivery-Leads") # agile
    },
    @{ 'TeamName' = 'MSTeamExperiments.TestChannel2'; 
    'Webhook' = 'https://outlook.office.com/webhook/<your-secure-string-here>';
    'MeetupGroups' = @("devops-sydney","Azure-Sydney-User-Group","Cloud-Engineering-Sydney", #devops
        "Sydney-Microsoft-User-Group", # programming
        "Sydney-Testers-and-Automators",
        "Continuous-Delivery-Sydney","Sydney-Scrum","Sydney-Agile-Scrum-Meetup","Sydney-Agile-Coach-Meetup","Agile-Sydney") # agile
    }
)

ForEach ($Team in $TeamMeetups) {
    Write-Output "MS Team: $($Team.TeamName)"
    $events = @()
    ForEach ($MeetupGroup In $Team.MeetupGroups) {
        Write-Output "MeetupGroup: $MeetupGroup"
        $uri = "https://api.meetup.com/$MeetupGroup/events?&sign=true&photo-host=public&scroll=next_upcoming&page=3&fields=group_photo,venue_visibility,visibility"
        try {
            $events += Invoke-RestMethod -Uri $Uri -ContentType 'application/json' -Method Get
        }
        catch [System.Exception] {
            throw $_
        }
    }

    $upcomingEvents = $events | Sort-Object time | Select-Object -First 12 # Maximum number of events to show in summary

    $maxLength = 90 # trial end error found that the short date format leaves 90 chars before value word wraps
    $fact = @()
    ForEach ($event In $upcomingEvents) {
        $eventTime = (Get-Date 1/1/1970).AddSeconds($event.time/1000).ToLocalTime()
        If ($eventTime -ge (Get-Date) -and $eventTime -le (Get-Date).AddDays(30)) { 
            $eventInfo = ($event.group.name + ': [' + $event.name )       
            If ($eventInfo.Length -gt $maxLength) { # try shortening the group name
                $shortGroupName = ($event.group.name -replace 'user|' -replace 'group|' -replace 'meetup|').Trim()
                $eventInfo = ($shortGroupName + ': [' + $event.name )
                If ($eventInfo.Length -gt $maxLength) { # meh, just truncate it
                    $eventInfo = ($eventInfo.substring(0,$maxLength-1) + '...')
                }
            }
            $fact += @{name = ($eventTime.ToString("ddd dd MMM HH:mm").ToUpper()); value = ($eventInfo + '](' + $event.link + ')' )} 
        }
    }

    # Message with just Facts will show 6 meetings with a 'see more' if there are more.
    $body = @{    
        Text = "Check out these upcoming events!"
        Sections = @(
        @{    
        Facts = @($fact)
        }
       )
    }
    Invoke-RestMethod -Method Post -Uri ($Team.Webhook) -Body (ConvertTo-Json $body -Depth 4) 

}
