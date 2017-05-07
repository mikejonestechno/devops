    Given 'the meetup api service is available' {
        # code here to ensure the api service is running on the server?
    }

    When "I request events for meetup group '(?<group>.+)'" {
        param($group)
        $uri = "https://api.meetup.com/$group/events?&page=1"
        $response = Invoke-RestMethod -Method Get $uri
    }

    Then "the returned JSON response contains session on '(?<expectedDescription>.+)'" {
        param($expectedDescription)
        $($response).description | Should -BeLike "*$expectedDescription*"
    }
