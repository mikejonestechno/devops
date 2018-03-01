Feature: 119 Member can update their profile

As a meetup member
I want to update my profile bio
So that it reflects changes in my personal interests

Scenario: Unauthenticated member cannot update profile bio
Given I have not authenticated with the API
When I update profile id 555123456
And set the bio to 'I am hacking'
Then the returned JSON response should return 400 bad request

Scenario Outline: Authenticated member can update profile bio
Given I have authenticated with the API
When I update profile id 555123456
And set the bio to '<bio>'
Then the returned JSON response should return OK
And the returned JSON response should return the bio like '<bio>'
Examples: Update bio and reset to previous value
| bio                                |
| I love PowerShell                  |
| Software Testing Automation is fun |


