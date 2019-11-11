package test

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

class LoadSimulation extends Simulation {

  val protocol = karateProtocol(
    "" -> pauseFor("get" -> 0, "post" -> 0),
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  val createDynamicUser = scenario("DynamicUser").exec(karateFeature("classpath:test/features/UserController.feature"))

  setUp(
    createDynamicUser.inject(atOnceUsers(5)).protocols(protocol),
  )
}