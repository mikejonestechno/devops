Feature: 106 Alert user on upcoming Meetup.com event 
   
    As a member of the powershell meetup group
    I want an alert if there is a meetup later today 
    So that I remember to go    


Scenario: Meetup.com API returns the description of an event 

  Given the meetup api service is available
   When I request events for meetup group 'Melbourne-PowerShell-Meetup'
   Then the returned JSON response contains session on 'PowerShell Pester tests' 
