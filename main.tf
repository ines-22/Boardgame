terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.25.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"  
}

resource "docker_image" "jenkins" {
  name = "ines222/jenkins:latest"
}

resource "docker_container" "jenkins" {
  name  = "jenkins-server"
  image = docker_image.jenkins.latest
  ports {
    internal = 8080  
    external = 8080  
  }
  ports {
    internal = 50000  
    external = 50000
  }
  volumes {
    host_path      = "/var/jenkins_home"
    container_path = "/var/jenkins_home"
  }
}

resource "docker_image" "nexus" {
  name = "sonatype/nexus3:latest"
}

resource "docker_container" "nexus" {
  name  = "nexus-server"
  image = docker_image.nexus.latest
  ports {
    internal = 8081  
    external = 8081  
  }
  volumes {
    host_path      = "/var/nexus-data"
    container_path = "/nexus-data"
  }
}


resource "docker_image" "sonarqube" {
  name = "sonarqube:community"
}

resource "docker_container" "sonarqube" {
  name  = "sonarqube-server"
  image = docker_image.sonarqube.latest
  ports {
    internal = 9000  
    external = 9000  
  }
  volumes {
    host_path      = "/var/sonarqube_data"
    container_path = "/opt/sonarqube/data"
  }
}
