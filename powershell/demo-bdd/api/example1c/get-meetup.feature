Feature: 106 Alert user on upcoming Meetup.com event

As a member of the test automation meetup group
I want an alert if there is a meetup later today
So that I remember to go

Scenario Outline: Meetup.com API returns the name of an event

Given the meetup api service is available
When I request events for <Meetup group>
Then the returned JSON response should have an event about <event name>

Examples: Meetup groups with simple characters in the event name
| Meetup group                   | Event name             |
| Software-Test-Automation-Group | testing                |

Examples: Meetup groups with special characters in the event name
| Meetup group                   | Event name             |
| Melbourne-PowerShell-Meetup    | #BeerOps*extravaganza! |

