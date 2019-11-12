Feature: Booking controller

  Background:
    * url demoUrl

  @getBookings
  Scenario Outline: Get bookings. Yo can apply several filters: by date, by user, by user and date, and all of them
    Given path 'booking'
    * def query = {id: <id>, date: <date>}
    And params query
    And retry until responseStatus == <responseStatus>
    When method GET
    And match $[*].idUser contains <response>
    Examples:
      | id                  | date         | responseStatus | response            |
      | 'pepe@pepe.pe1-0.2' | '2019-01-01' | '200'          | 'pepe@pepe.pe1-0.2' |

  Scenario Outline: Dont get bookings with incorrect dates or users
    Given path 'booking'
    * def query = {id: <id>, date: <date>}
    And params query
    And retry until responseStatus == <responseStatus>
    When method GET
    Examples:
      | id                  | date         | responseStatus |
      | 'fakeId'            | '2019-01-01' | '200'          |
      | 'pepe@pepe.pe1-0.2' | '2001-41-41' | '500'          |

#    Create a booking with .json file
  @booking
  Scenario Outline: Creates booking for a user with json stored data
    Given path 'booking'
    And request read(<booking>)
    When method POST

    Examples:
      | booking                            |
      | 'testResources/createBooking.json' |

#    Used for call in dynamic scenario
  @bookingDynamic
  Scenario: Creates booking for a user
    Given path 'booking'
    And request {date:'#(date)',destination:'#(destination)', id:'#(userID)',origin:'MAD'}
    When method POST
    And retry until responseStatus == 200


#    Create an user, create a booking with the id and get all the bookings with the id
  @ignore
  @dynamicScenario
  Scenario: Creates an User
    * def createUser = call read('UserController.feature@createUser') {email:'dynamicTest@test', name: 'dynamicTest'}
    * def userID =  createUser.userID
    * def booking = call read('BookingController.feature@bookingDynamic') {date:'#(date)', destination:'BCN', id:'#(userID)',origin:'MAD'}
    Given path 'booking'
    * def query = {id: '#(userID)', date: '2019-01-01'}
    And params query
    When method GET


#  Test flow requested in Performance test
  @ignore
  @performanceScenario
  Scenario: We need all the http requests that our users are going to execute, step by step:
#    Create a new user and getting his id
    * def createUser = call read('UserController.feature@createUser') {email:'performanceTest@test', name:'performanceTest'}
    * def userID =  createUser.userID
##
###    Getting today and yesterday dates and create a booking with each one
    * def utilities = Java.type('functionalTest.Utilities')
    * def gt = new utilities()
    * def yesterday = gt.getYesterdayDate()
    * def today = gt.getTodayDate()

    * def bookingYesterday = call read('BookingController.feature@bookingDynamic') {date:'#(yesterday)', destination:'BCN', id:'#(userID)',origin:'MAD'}
    * def bookingToday = call read('BookingController.feature@bookingDynamic') {date:'#(today)', destination:'BCN', id:'#(userID)',origin:'MAD'}
##
###    Getting all today bookings
    Given path 'booking'
    And param date = today
    When method GET


#    Getting all users and then a random one
    * def get = call read('UserController.feature@getAllUsers')
    * def allUsers = get.count
    * def random = gt.getRandomNumber(0,allUsers)
    * def randomID = get.res[random]


#    Get all bookings for the random user
    Given path 'booking'
    And param id = randomID
    When method GET
    * def res = response