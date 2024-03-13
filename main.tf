terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_network" "my_red" {
  name = "my_red"
}

resource "docker_volume" "db_volume" {
  name = "db_volume"
}

resource "docker_container" "wordpress" {
  image = "wordpress"
  name  = "wordpress"
  ports {
    internal = 80
    external = 8080
  }
  env = [
    "WORDPRESS_DB_HOST     = ${var.db_hostname}",
    "WORDPRESS_DB_NAME     = ${var.db_name}",
    "WORDPRESS_DB_USER     = ${var.db_usr}",
    "WORDPRESS_DB_PASSWORD = ${var.db_passwd}"
  ]
  networks_advanced {
    name = docker_network.my_red.name
  }
}

resource "docker_container" "mariadb" {
  image = "mariadb"
  name  = "mariadb"
  env = [
    "MARIADB_ROOT_PASSWORD = *vVjN4JxS!6O*#DW",
    "MARIADB_DATABASE      = wordpress"
  ]
  networks_advanced {
    name = docker_network.my_red.name
  }
  volumes {
    volume_name    = docker_volume.db_volume.name
    container_path = "/var/lib/mysql"
  }
}
