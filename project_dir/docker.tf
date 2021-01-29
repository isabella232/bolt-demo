# Configure the Docker provider
provider "docker" {
  host = "tcp://127.0.0.1:2375"
}

# Create a container
resource "docker_container" "nginx" {
  image = "${docker_image.nginx.latest}"
  count = "3"
  name  = "tf_docker_${count.index}"
  ports {
    internal = 880 + count.index
    external = 880 + count.index
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

