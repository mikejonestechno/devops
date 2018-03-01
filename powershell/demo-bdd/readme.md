# BDD Behaviour Driven Development using PowerShell  

The PowerShell Pester framework supports automated tests using the Gherkin format.

For example
````
Feature: 106 Alert user on upcoming Meetup.com event

As a member of the test automation meetup group
I want an alert if there is a meetup later today
So that I remember to go

Scenario: Meetup.com API returns the name of an event

Given the meetup api service is available
When I request events for meetup group 'Software-Test-Automation-Group'
Then the returned JSON response should have an event about 'testing'
````

The Gherkin format creates executable specifications. 
The power of PowerShell usually means that only one or two lines of 'code' are needed to automate the steps for each scenario.
PowerShell itself is reasonably human readable in it's own right and the Gherkin format makes it even easier.

#### Getting Started
Update to the latest PowerShell for Windows (v5.1) or PowerShell Core for all platforms (v6)
Install / update to the latest PowerShell Pester test framework
```
Install-Module Pester -Force
```

For the API test example 2 updating a profile in meetup.com, you will need to replace the Profile ID and API key with your own values.

Learn to automate.

[Example BDD API Automated Tests](api)

[Example BDD Infrastructure Tests](infra)

[Example BDD Operational tests for a log file script](logs)
