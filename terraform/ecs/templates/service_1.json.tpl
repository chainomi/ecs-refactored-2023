[
  {
    "name": "${name}",
    "image": "${container_image}:${container_image_version}",
    "essential": true,
    "cpu": ${cpu},
    "memory": ${memory},
    "links": [],
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${host_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "WORDPRESS_DB_HOST",
        "value": "mysql.local"
      },
      {
        "name": "WORDPRESS_DB_USER",
        "value": "wordpress"
      },
      {
        "name": "WORDPRESS_DB_PASSWORD",
        "value": "wordpress"
      },
      {
        "name": "WORDPRESS_DB_NAME",
        "value": "wordpress"
      },
      {
        "name": "WORDPRESS_DB_",
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