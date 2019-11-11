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
  Scenario Outline: Creates booking for a user
    Given path 'booking'
    And request read(<booking>)
    When method POST
    And retry until responseStatus == 200

    Examples:
      | booking                            |
      | 'testResources/createBooking.json' |

#    Used for call in dynamic scenario
  @bookingDynamic
  Scenario: Creates booking for a user
    Given path 'booking'
    And request {date:'2019-01-01',destination:'BCN', id:'#(userID)',origin:'MAD'}
    When method POST
    And retry until responseStatus == 200


#    Create an user, create a booking with the id and get all the bookings with the id
  @dynamicScenario
  Scenario: Creates an User
    * def createUser = call read('UserController.feature@createUser') {email:'dynamicTest@test', name: 'dynamicTest'}
    * def userID =  createUser.userID
    * def booking = call read('BookingController.feature@bookingDynamic') {date:'2019-01-01', destination:'BCN', id:'#(userID)',origin:'MAD'}
    Given path 'booking'
    * def query = {id: '#(userID)', date: '2019-01-01'}
    And params query
    When method GET