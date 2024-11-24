pipeline 
{
    agent any

    tools 
    {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment 
    {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') 
        {
            steps 
            {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/ines-22/Boardgame.git'
            }
        }

        stage('Compile') 
        {
            steps 
            {
                sh "mvn compile"
            }
        }

        stage('Test') 
        {
            steps 
            {
                sh "mvn test"
            }
        }

        stage('File System Scan') 
        {
            steps 
            {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }

        stage('SonarQube Analysis') 
        {
            steps 
            {
                withSonarQubeEnv('sonar') 
                {
                    sh """ $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=BoardGame \
                        -Dsonar.projectKey=BoardGame \
                        -Dsonar.host.url=http://192.168.1.26:9000 \
                        -Dsonar.java.binaries=target/classes \
                        -X """
                }
            }
        }

        stage('Build') 
        {
            steps 
            {
                sh "mvn package"
            }
        }

        stage('Publish to Nexus') 
        {
            steps 
            {
                withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) 
                {
                    sh "mvn deploy -X"
                }
            }
        }

        stage('Build & Tag Docker Image') 
        {
            steps 
            {
                script 
                {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') 
                    {
                        sh "cp /var/jenkins_home/workspace/BoardGame/target/database_service_project-0.0.4.jar ."
                        sh "docker build -t ines222/boardgame:latest ."
                    }
                }
            }
        }

        stage('Docker Image Scan') 
        {
            steps 
            {
                sh "trivy image --format table -o trivy-fs-report.html ines222/boardgame:latest"
            }
        }

        stage('Push Docker Image') 
        {
            steps 
            {
              script 
              {
                  withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') 
                    {
                        sh "docker push ines222/boardgame:latest"
                    }
                }
            }
        }

        stage('Deploy with Ansible') 
        {
          steps 
            {
                sshPublisher(publishers: [sshPublisherDesc(
                    configName: 'ansible',
                    transfers: [sshTransfer(
                        cleanRemote: false,
                        execCommand: 'ansible-playbook /home/ines/boardgame_deploy.yml',
                        execTimeout: 120000
                    )]
                )])
            }
        }
    }

    post 
    {
      always 
      {
            mail to: 'inesboukhris20@gmail.com',
                subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
                body: "${env.BUILD_URL} has result ${currentBuild.result}"
      }
    }
}
