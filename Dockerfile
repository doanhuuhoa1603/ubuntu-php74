FROM ubuntu:20.04

WORKDIR /var/www

# Disable User interaction
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update OS
RUN apt -y update

# Remove Apache2
RUN apt -y remove apache2

# Install packages & dependencies
RUN apt -y install wget \
    nano \  
    curl \
    git \
    zip \
    unzip \
    nginx \
    libjpeg-dev \
    libpng-dev \
    libpq-dev \
    zlib1g-dev \
    libzip-dev \
    libxpm-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libssh2-1 \
    supervisor \
    cron \
    gcc make libssh2-1-dev \
    php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Update OS Policy
RUN echo "exit 0" > /usr/sbin/policy-rc.d

# Remove Nginx defaut config
RUN unlink /etc/nginx/sites-enabled/default

# COPY cron file
COPY cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron
RUN crontab /etc/cron.d/cron

# Start nginx
# CMD ["nginx", "-g", "daemon off;"]
CMD /etc/init.d/php7.4-fpm restart && nginx -g "daemon off;" && cron