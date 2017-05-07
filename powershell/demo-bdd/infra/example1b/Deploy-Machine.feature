Feature: Create application server for myApp    

Scenario: Application server resources

  Given the deployment script is successful
   Then the machine has 4 CPU logical processors
    And the machine has 8GB of RAM

