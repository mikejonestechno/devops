Feature: 106 Alert user on upcoming Meetup.com event

As a member of the test automation meetup group
I want an alert if there is a meetup later today
So that I remember to go

Scenario: Meetup.com API returns the name of an event

Given the meetup api service is available
When I request events for meetup group 'Software-Test-Automation-Group'
Then the returned JSON response should have an event about 'testing'
