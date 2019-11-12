API AUTOMATION STEPS :
-
- The test orchestration feature will be launched by the gradle ApiTest task. This feature contains the scenarios of the UploadListProducts and DeleteProducts features.
 The product json files will be uploaded one by one using the api and then will be checked by a mini selenium script that the products are in the application and each product can be selected and added to the cart.
 Then all the uploaded products will be get, extracted their id and deleted one by one. 


FRAMEWORK:
-
- Used karate for Api automation and Cucumber reports generated for results.
- Used karate with Gatling for Performance automation and Gatling reports generated for results .
- Get dependencies and task run with Gradle, optionally with parameters (commented in the test for run locally).
- Optional JenkinsFile that will run the test cases in a CI/CD enviroment with kubernetes.

ASSUMPTIONS:
-
- Needs Gradle for run the task and get the dependencies.
- In the Performance test instrucctions, 4.- From all user list choose randomly one of them and get all bookings, because a random user is selected, maybe it not has bookings available.


HOW TO RUN :
-
Api test:
- Single scenario > Simple right click and run the scenario
- Single feature > Simple right click and run the feature

All the features and Generate reports  > Windows,using a terminal, gradlew ApiTest; Linux, using a terminal ./gradlew apiTest

The generate reports will be in target/cucumber-html-reports

Base url can be passed from a Jenkins file or the Gradle task from the terminal, then the base.URL in the karate-config.js will get that dynamic variable, actually that is commented for use a fix variable in local enviroment.

Performance test:
-
It will run the @performanceScenario that perform the Test flow required in the document and Generate reports  > Windows,using a terminal, gradlew gatlingRun; Linux, using a terminal ./gradlew gatlingRun
