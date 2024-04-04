def STATUS_COLOR_MAP = [
  "SUCCESS": "good",
  "FAILURE": "danger",
  "UNSTABLE": "danger",
  "ABORTED": "danger"
]

def branchesName() {
  def branchName = "${env.BRANCH_NAME}"

  if (branchName == "uat") {
    return "uat"
  } else if (branchName == "master") {
    return "master"
  }
}

def defineRegistry() {
  def branchName = "${env.BRANCH_NAME}"

  if (branchName == "uat") {
    return "uat"
  } else if (branchName == "master") {
    return "prod"
  } 	  
}

def defineNamespace() {
  def branchName = "${env.BRANCH_NAME}"

  if (branchName == "UAT") {
    return "uat"
  } else if (branchName == "master") {
    return "prod"
  }
}

def defineNodeenv() {
  def branchName = "${env.BRANCH_NAME}"

if (branchName == "UAT") {
    return "uat"
  } else (branchName == "master") {
    return "production"
  } 
}  

pipeline {
  environment {
    branch = branchesName()
    registry = defineRegistry()
    namespace = defineNamespace()
    node_env = defineNodeenv()
    service_name = "${env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')}"
  }
  agent any
  stages {
    stage('Build Image') {
      when {
        anyOf {
          branch 'UAT'
          branch 'master'
        }
      }
      steps{
        script {
          sh "docker build -t ${env.service_name} --no-cache --build-arg namespace=${env.node_env} ."
        }
      }   
    }
    stage('Tag Image') {
      when {
        anyOf {
            branch 'UAT'
            branch 'master'
        }
      }
      steps{
        script {
          sh "docker tag ${env.service_name} hub.docker.com/${env.namespace}/${env.service_name}:${BUILD_TIMESTAMP}"
          sh "docker tag ${env.service_name} hub.docker.com/${env.namespace}/${env.service_name}:${BUILD_TIMESTAMP}"
        }
      }      
    }

    stage ('Image Push to docker ') {
      when {
        anyOf {
          branch 'UAT'
          branch 'master'
        }
      }
      steps{
        script {
          if  (env.branch != 'master') {  
            withCredentials([usernamePassword(credentialsId: 'docker-hub-credential', passwordVariable: 'PSW', usernameVariable: 'USR')]) {
              sh 'docker login -u $USR -p $PSW hub.docker.com'
              sh "docker push hub.docker.com/${env.namespace}/${env.service_name}:${BUILD_TIMESTAMP}"
            }
          } else {  
            withCredentials([usernamePassword(credentialsId: 'docker-hub-credential', passwordVariable: 'PSW', usernameVariable: 'USR')]) {
              sh 'docker login -u $USR -p $PSW hub.docker.com'
              sh "docker push hub.docker.com/${env.namespace}/${env.service_name}:${BUILD_TIMESTAMP}"
            }	  
          }
        }
      }
    }
  }
}
