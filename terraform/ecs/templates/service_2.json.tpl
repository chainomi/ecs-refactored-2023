[
  {
    "name": "${name}",
    "image": "${container_image}:${container_image_version}",
    "essential": true,
    "cpu": ${cpu},
    "memory": ${memory},
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port},
        "protocol": "tcp"
      }
    ],
        "environment": [
      {
        "name": "MYSQL_DATABASE",
        "value": "wordpress"
      },
      {
        "name": "MYSQL_USER",
        "value": "wordpress"
      },
      {
        "name": "MYSQL_PASSWORD",
        "value": "wordpress"
      },
      {
        "name": "MYSQL_ROOT_PASSWORD",
        "value": "wordpress"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${name}-log-stream"
      }
    }
  }
]