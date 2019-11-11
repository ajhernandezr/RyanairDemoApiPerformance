Feature: User Controller

  Background:
    * url demoUrl

  Scenario Outline: Get a user with required id
    Given path 'user'
    And param id = <id>
    When method GET
    And match $.id contains <id>
    Examples:
      | id                  |
      | 'pepe@pepe.pe1-0.2' |

    #    Create an user with .json file
  Scenario: Creates a new user with Json
    Given path '/user'
    And request read('testResources/createUser1.json')
    When method POST
    And match $.email contains "test@testaa"
    * def res = response
    And def userID = res.id

  @createUser
  Scenario: Creates a new user with dynamic parameters
    Given path '/user'
    And request {email:'#(email)', name:'#(test)'}
    When method POST
    * def res = response
    And def userID = res.id

  Scenario: Get all the users
    Given path '/user/all'
    And retry until responseStatus ==200
    When method GET