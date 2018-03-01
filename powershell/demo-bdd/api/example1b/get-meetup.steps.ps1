Given "the meetup api service is available" {
    # code here to ensure the api service is running on the server?
}
When "I request events for meetup group 'Software-Test-Automation-Group'"{
    $uri = "https://api.meetup.com/Software-Test-Automation-Group/events/?page=1&scroll=recent_past"
    $resp = Invoke-RestMethod -Uri $uri -Method Get
}
Then "the returned JSON response should have an event about 'testing'" {
    $($resp).name | Should -BeLike '*testing*'
}

When "I request events for meetup group 'Melbourne-PowerShell-Meetup'"{
    $uri = "https://api.meetup.com/Melbourne-PowerShell-Meetup/events/?page=1&scroll=recent_past"
    $resp = Invoke-RestMethod -Uri $uri -Method Get
}
Then "the returned JSON response should have an event about '#BeerOps extravaganza!'" {
    $($resp).name | Should -BeLike '*#BeerOps*extravaganza!*'
}