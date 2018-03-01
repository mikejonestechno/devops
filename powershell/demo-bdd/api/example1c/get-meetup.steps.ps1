Given "the meetup api service is available" {
    # code here to ensure the api service is running on the server?
}

When "I request events for (?<meetupGroup>.*)"{
    param($meetupGroup)
    $uri = "https://api.meetup.com/$meetupGroup/events/?page=1&scroll=recent_past"
    $resp = Invoke-RestMethod -Uri $uri -Method Get
}

Then "the returned JSON response should have an event about (?<eventName>.*)" {
    param($eventName)
    $($resp).name | Should -BeLike "*$eventName*"
}
