    Given 'the meetup api service is available' {
        # code here to ensure the api service is running on the server?
    }

    When "I request events for meetup group 'Melbourne-PowerShell-Meetup'" {
        $uri = "https://api.meetup.com/Melbourne-PowerShell-Meetup/events?&page=1"
        $response = Invoke-RestMethod -Method Get $uri
    }

    Then "the returned JSON response contains session on 'PowerShell Pester tests'" {
        $($response).description | Should -BeLike '*PowerShell Pester tests*'
    }
