# Loop through the groups, if there is a meetup within next 24 hours then post it!
# Observed that the meetup group photo is squished to square shape in Teams. Not sure there is much we can do about that!

$TeamMeetups = (@{ 'TeamName' = 'MSTeamExperiments.TestChannel1'; # human readable name just to make it easier to manage this hastable
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
    ForEach ($MeetupGroup In $Team.MeetupGroups) {

        Write-Output "MeetupGroup: $MeetupGroup"
        $event = $null
        $body = @()
        $uri = "https://api.meetup.com/$MeetupGroup/events?&sign=true&photo-host=public&scroll=next_upcoming&page=1&fields=group_photo,venue_visibility,visibility"

        try {
            $event = Invoke-RestMethod -Uri $Uri -ContentType 'application/json' -Method Get
        }
        catch [System.Exception] {
            throw $_
        }

        $event.group.photo

        $eventTime = (Get-Date 1/1/1970).AddSeconds($event.time/1000).ToLocalTime()

        If ($eventTime -ge (Get-Date) -and $eventTime -le (Get-Date).AddDays(1)) {
   
            Write-Output "Meeting soon! Lets message the Team!" 

            <# Uuurrrrgggghhh!
             # Fancy quotes break the payload. Even $_.plain_text_description can contain fancy quotes!   
             # Also [char]160 is a non-breaking space char which doesnt break payload but turns into ? char when pushed to Teams
             # http://stackoverflow.com/questions/27020671/remove-xa0-from-powershell-string
             #>
            If ($event.visibility -eq 'public') {
                $unescapeDesc = ([regex]"[\u0080-\uffff]").Replace($event.description, { param($m) "&#$([int][char]$m.Value);" })
            } Else {
                $unescapeDesc = ('Meeting details are shown only to members of the ' + $event.group.name)
            }
            # Generate the same map link that meetup.com display on their pages
            If ($event.venue_visibility -eq 'public') {
                $map ="https://maps.google.com/maps?f=q&hl=en&q=" + [System.Web.HttpUtility]::UrlEncode($event.venue.name + ',' + $event.venue.address_1 + ',' + $event.venue.city + ',' + $event.venue.country)
                $venue = ($event.venue.name + ', ' +  $event.venue.city + ' ([View Map](' + $map + '))' )
            } Else {
                $venue = ('Location is shown only to members of the ' + $event.group.name)
            }

            $body = @{    Title = ('Reminder: ' + $event.name + ' at ' + $eventTime.ToString("h:mm tt") )
                Summary = "Reminder for upcoming event"
                themeColor = "E81123"
                Sections = @(
                @{
                ActivityTitle = '[' + $event.group.name + '](' + $event.link + ')'
                ActivitySubtitle = '**' + ($eventTime.ToString("dddd d MMMM h:mm tt") + '** (' + $event.yes_rsvp_count + ' are going)' )
                ActivityText = $venue
                ActivityImage = ($event.group.photo.thumb_link)
                Text = '## Like this message if you are going! @mention others that may be interested!'
                }
                @{ Text = ($unescapeDesc)
                }
               )
            }

            # Post message to Teams webhook
            try {
                Invoke-RestMethod -Method Post -Uri ($Team.Webhook) -Body (ConvertTo-Json $body -Depth 4) 
            }
            catch [System.Exception] {
                throw $_
            }
        }
    }
}

