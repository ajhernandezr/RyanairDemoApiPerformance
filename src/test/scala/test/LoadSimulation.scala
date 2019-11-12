package test

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration._

class LoadSimulation extends Simulation {

  val protocol = karateProtocol(
    "" -> pauseFor("get" -> 0, "post" -> 0),
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  val unitTestScenario = scenario("unitTestScenario").exec(karateFeature("classpath:test/features/BookingController.feature@performanceScenario"))
  val loadTestScenario = scenario("loadTestScenario").exec(karateFeature("classpath:test/features/BookingController.feature@performanceScenario"))
  val distributedLoadTestScenario = scenario("distributedLoadTestScenario").exec(karateFeature("sclasspath:test/features/BookingController.feature@performanceScenario"))

  setUp(
    unitTestScenario.inject(rampUsers(1) during (5 seconds)).protocols(protocol),
    loadTestScenario.inject(rampUsers(10) during (5 minutes)).protocols(protocol),
    distributedLoadTestScenario.inject(constantUsersPerSec(1) during (60 seconds),
    constantUsersPerSec(3)during (60 seconds),
    constantUsersPerSec(1)during (60 seconds)).protocols(protocol)
  )
}