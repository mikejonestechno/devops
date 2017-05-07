Scenarios... api, infra, archive logs

VSTS PBI
Copy ac to .feature and execute
Save as .steps.ps1 

write a failing test (invoke api that does not yet exist)
make the test pass   (make the api) 
 ...and re-run to ensure the test passes when it should pass and fails when it should fail
refactor and clean up BOTH app code and test code

given we are reasonably experienced with general powershell...
We can skip the 'coding' bit to make the test pass 
to focus on how to create the tests 


Hint 
        $uri = "https://api.meetup.com/Melbourne-PowerShell-Meetup/events?&page=1"

        $($response).description | Should -BeLike '*PowerShell Pester tests*'
