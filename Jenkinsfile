pipeline {
    agent any

    tools {
        nodejs 'Node 18'
    }

    stages {        
        stage('Test') {
            steps {
                sh 'npm install'
                sh 'npm test'
            }
        }
    
    stage('Build Docker Image') {
        when { 
            anyOf {
                branch 'main'
                branch 'develop'
                }
        }
        steps {
                script {
                    def imageName = 'ds8reactapp'
                    if (env.BRANCH_NAME == 'develop') {
                        imageName = "${imageName}-staging"
                    }
                    // Stop the Docker container if it's running
                    sh "/usr/local/bin/docker stop ${imageName} || true"
                    // Remove the Docker container
                    sh "/usr/local/bin/docker rm ${imageName} || true"
                    // Build the Docker image
                    sh "/usr/local/bin/docker build --platform linux/amd64 -t ${imageName} ."
                }
        }
    }
    stage('Run Docker Image') {
            when {
        anyOf {
            branch 'main'
            branch 'develop'
                }
            }
            steps {
                script {
                def containerName = 'ds8reactapp'
                def hostPort = '3003'
                def api1Url = 'http://localhost:3001/api'    
                if (env.BRANCH_NAME == 'develop') {
                    containerName = "${containerName}-staging"
                    hostPort = '3004'
                    api1Url = 'http://localhost:3002/api'
                }
                // Run the Docker image
                //sh "/usr/local/bin/docker run -d -p ${hostPort}:3003 --name ${containerName} ds8reactapp"    
                sh "/usr/local/bin/docker run -d --publish 3003:3003 --name ds8reactapp ds8reactapp"
                sleep 30
                sh "/usr/local/bin/docker logs ${containerName}"    
                }
            }
    }
    stage('Mini Smoke Test') {
            when {
              anyOf {
            branch 'main'
            branch 'develop'
                }
            }
            steps {
                script {
                    def hostPort = '3003'
                    if (env.BRANCH_NAME == 'develop') {
                        hostPort = '3004'
                    }
                    // Initialize a counter for the number of attempts
                    def attempts = 0
                    // Run the test in a loop until it succeeds or the maximum number of attempts is reached
                    while (attempts < 20) {
                        echo "Attemps: ${attempts}"
                        // Perform an HTTP GET request to the application and get the status code
                        def pingResult = sh(script: "curl -f http://localhost:${hostPort} || true", returnStdout: true).trim()
                        echo "Ping result: ${pingResult}"
                        if (!pingResult.contains('Hello')) {
                            // If the test failed, wait for 10 seconds before trying again
                            sleep 15
                        } else {
                            // If the test succeeded, break the loop
                            break
                        }
                        // Increment the number of attempts
                        attempts++
                            
                    }
                    // If the test didn't succeed after the maximum number of attempts, fail the job
                    if (attempts >= 20) {
                        error('Smoke test failed after 20 attempts')
                    }
                }
                
            }
    }
  }
}
