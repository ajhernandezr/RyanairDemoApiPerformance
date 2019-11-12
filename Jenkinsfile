pipeline {
  agent {
    kubernetes {
      label 'qa'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    pod_name: qa-online-services
spec:
  serviceAccountName: jenkins
  volumes:
    - name: dshm
      emptyDir: 
        medium: Memory
  containers:
  - name: base
    image: gcr.io/jenkinsxio/builder-base:0.0.54
    privileged: true
    command:
    - cat
    tty: true
"""
    }
  }
  options {
    //buildDiscarder(logRotator(numToKeepStr: '5'))
    disableConcurrentBuilds()
    //timestamps()
  }
  parameters {
    string(defaultValue: "http://127.0.0.1:8900/",
            description: 'Enter service URL:', name: 'base_URL')
    choice(name: 'karate_ENV', choices: ['beta', 'prod'], description: 'Select Environment')
  }
  stages {
    stage('Compile') {
      steps {
        container('base') {
          sh './gradlew clean build'
        }
      }
    }
    stage('Performance tests') {
      steps {
        container('base') {
          echo "Service URL is ${params.base_URL}"
          sh "./gradlew gatlingRun -Dbase.URL=${params.base_URL}"
        }
      }
      post {
        success {
          cucumber fileIncludePattern: '**/target/surefire-reports/*.json', sortingMethod: 'ALPHABETICAL'
        }
        unsuccessful {
          cucumber buildStatus: 'FAILED', fileIncludePattern: '**/target/surefire-reports/*.json', sortingMethod: 'ALPHABETICAL'
        }
      }
    }
  }
  post {
    always {
      emailext attachLog: true, body: '$DEFAULT_CONTENT', compressLog: true, recipientProviders: [requestor(), culprits()], replyTo: '$DEFAULT_REPLYTO', subject: '$DEFAULT_SUBJECT'
      //cleanWs()
    }
  }
}