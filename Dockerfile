FROM ubuntu:14.04

RUN \
  apt-get update && \
  locale-gen en_US.UTF-8 && \
  export LANG=en_US.UTF-8 && \
  apt-get install -y software-properties-common \
  && \
  add-apt-repository -y ppa:ondrej/php5-5.6 && \
  apt-get update && \
  apt-get install -y \
    php5-cli \
  && \
  adduser --disabled-password --gecos '' r && \
  usermod -aG sudo r && \
  echo "r ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN \
  apt-get update && \
  apt-get install -y build-essential autoconf libssl-dev liblua5.1-dev && \
  apt-get install -y php5-dev php-pear

RUN \
  apt-get install -y wget curl

WORKDIR /root

RUN \
  cd /usr/bin && \
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar composer

RUN \
  cd /root && \
  mkdir /root/bench-aerospike && \
  cd /root/bench-aerospike && \
  composer require aerospike/aerospike-client-php "*" && \
  cd vendor/aerospike/aerospike-client-php/ && \
  find src/aerospike -name "*.sh" -exec chmod +x {} \; && \
  composer run-script post-install-cmd

COPY conf/etc/php5/cli/php.ini /etc/php5/cli/php.ini
COPY conf/etc/php5/cli/conf.d/aerospike.ini /etc/php5/cli/conf.d/aerospike.ini

ENV HOME /root

WORKDIR /root/bench-aerospike

CMD bash
