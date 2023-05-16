pipeline {

    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = 'us-west-1'
       }

    stages {      
        stage('Git Checkout') {
            steps { 
                    echo "Checking out code from github"
                    checkout scm
                 }
               }      
              
        stage('Build Stage') {
           agent { docker 'maven:3.5-alpine' }
           steps { 
                   echo 'Building stage for the app...'
                   sh 'mvn compile'
           }
        }

        stage('Test App') {
           agent { docker 'maven:3.5-alpine' }
           steps {
                   echo 'Testing stage for the app...'
                   sh 'mvn test'
                   junit '**/target/surefire-reports/TEST-*.xml'

           }
        }

        stage('Packaging Stage') {
           agent { docker 'maven:3.5-alpine' }
           steps {
                   echo 'Packaging stage for the app..'
                   sh 'mvn package'
           }
        }

        stage('Docker Image Build') {
            steps {
                echo 'Bulding docker image...'
                sh "docker build -t product_service:${env.BUILD_NUMBER} ."
            }
        }        

        stage('Push Docker Image to ECR') {
                 agent { docker 'ventx/helm-awscli-kubectl-terraform:tf-v0.12.24' }
                 steps {
                    sh 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID'
                    sh 'export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY'
                    sh 'export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION'
                    sh 'aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 634639955940.dkr.ecr.us-west-1.amazonaws.com'
                    sh 'docker tag product_service:${env.BUILD_NUMBER} 634639955940.dkr.ecr.us-west-1.amazonaws.com/product_service:${env.BUILD_NUMBER}'
                    sh 'docker push 634639955940.dkr.ecr.us-west-1.amazonaws.com/product_service:${env.BUILD_NUMBER}'
                 }
              }
           }       
        }

    post {
      failure {
        mail to: 'richgoldd2@gmail.com',
            subject: 'Failed pipeline: ${currentBuild.fullDisplayName}',
            body: 'Pipeline failed for dev ${env.BUILD_URL}'
         }
       }
     }
  
