Given "the meetup api service is available" {
    # code here to ensure the api service is running on the server?
}
When "I request events for meetup group 'Software-Test-Automation-Group'"{
    $uri = "https://api.meetup.com/Software-Test-Automation-Group/events/?page=1"
    $resp = Invoke-RestMethod -Uri $uri -Method Get
}
Then "the returned JSON response should have an event about 'testing'" {
    $($resp).name | Should -BeLike '*testing*'
}
