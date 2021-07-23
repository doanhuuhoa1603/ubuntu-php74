# Ubuntu 20.04 with PHP/Redis/Memcached/MariaDB Project

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Author](#author)

## About <a name = "about"></a>

  This project contains Docker & Docker config files for Ubuntu 20.04 (host), MariaDB, Redis, Memcached

## Getting Started <a name = "getting_started"></a>

  These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.

### Prerequisites

  You need to install Docker & Docker Compose first in order to work with this project.

- [Docker Engine: Installation Guide](https://docs.docker.com/engine/install/)
- [Docker Compose: Installation Guide](https://docs.docker.com/compose/install/)


### Installing

1. Prepare your .env file

  You can copy the .env.example content and change the values inside. Your .env file shoud be similar to this
  ```
  DB_DATABASE="example_db"
  DB_USERNAME="db_user"
  DB_PASSWORD="db_password"
  DB_ROOT_PASSWORD="root_password"
  DB_ROOT_HOST="localhost" # DB Root Host (Set your Server IP when using Remote Access)
  FORWARD_DB_PORT=3306 # DB Port
  FORWARD_PHPMYADMIN_PORT=8888 # PhpMyAdmin Port
  FORWARD_REDIS_PORT=6379 # Redis Port
  ```

2. Copy your code

  Create a new folder inside <b>sites</b> to contains your code and log files

  The folder structure should be like this

  ```
  sites/your_project/public_html <== Put your code here
  sites/your_project/logs <== You just need to create an empty folder
  ```

3. Prepare Nginx Configurations
   
  Please put all your nginx configuration files inside the folder <b>nginx</b>

  Nginx example conf for running a PHP-based site
  <pre>
    <code>
    server {
      listen 80 default_server;
        
      # access_log off;
      access_log /var/www/your_project/logs/access.log;
      # error_log off;
      error_log /var/www/your_project/logs/error.log;
      
      root /var/www/your_project/public_html/public;
      index index.php index.html index.htm;
      server_name example.com;
    
      location / {
        try_files $uri $uri/ /index.php?$query_string;
      }
      # Remove trailing slash to please routing system.
      if (!-d $request_filename) {
        rewrite     ^/(.+)/$ /$1 permanent;
      }
      
      # Custom configuration
      include /var/www/your_project/public_html/*.conf;
    
      location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include /etc/nginx/fastcgi_params;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_connect_timeout 1000;
        fastcgi_send_timeout 1000;
        fastcgi_read_timeout 1000;
        fastcgi_buffer_size 256k;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;
        fastcgi_temp_file_write_size 256k;
        fastcgi_intercept_errors on;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      }
    }
    </code>
  </pre>

## Usage <a name = "usage"></a>

  You can now run your project using the command:

  ```
  docker-compose up -d
  ```
  * Notice:

  You may need to get access inside the ubuntu container to run whatever you want by using the command:

  ```
  docker exec -it hpd_web bash
  ```
## Author <a name = "author"></a>
<b>Doan Huu Hoa<b> (<doanhuuhoa1603@gmail.com>)