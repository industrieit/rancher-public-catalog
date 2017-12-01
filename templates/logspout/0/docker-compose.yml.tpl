version: '2'
services:
  logspout:
    image: flaccid/logspout:gelf
    stdin_open: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    tty: true
    environment:
      INACTIVITY_TIMEOUT: 1m
    command:
      - "gelf://${graylog_server_name}:${graylog_server_port}"
    labels:
      io.rancher.container.pull_image: always
      io.rancher.scheduler.global: 'true'
