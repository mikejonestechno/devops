# BDD Behaviour Driven Development using PowerShell  

The PowerShell Pester framework supports automated tests using the Gherkin format.

For example
````
Feature: 106 Alert user on upcoming Meetup.com event 
   
    As a member of the powershell meetup group
    I want an alert if there is a meetup later today 
    So that I remember to go    


Scenario: Meetup.com API returns the description of an event 

  Given the meetup api service is available
   When I request events for meetup group 'Melbourne-PowerShell-Meetup'
   Then the returned JSON response contains session on 'PowerShell Pester tests' 
````

The Gherkin format creates executable specifications. 
The power of PowerShell usually means that only one or two lines of 'code' are needed to automate the steps for each scenario.
PowerShell itself is reasonably human readable in it's own right and the Gherkin format makes it even easier.

Learn to automate.

[Example BDD API Automated Tests](api)

[Example BDD Infrastructure Tests](infra)

[Example BDD Operational tests for a log file script](logs)
