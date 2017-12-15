version: '2'
services:
  mongo:
    image: "mongo:3"
    volumes:
      - graylog-mongo-volume:/data/db
    {{- if ne .Values.mongodb_host_label "" }}
    labels:
      io.rancher.scheduler.affinity:host_label: ${mongodb_host_label}
    {{- end}}
  elasticsearch:
    image: elasticsearch:2-alpine
    stdin_open: true
    tty: true
    command:
      - elasticsearch
      - -Des.cluster.name=graylog
    volumes:
      - graylog-elasticsearch-volume:/usr/share/elasticsearch/data
    labels:
        io.rancher.container.pull_image: always
        {{- if ne .Values.elasticsearch_host_label "" }}
        io.rancher.scheduler.affinity:host_label: ${elasticsearch_host_label}
        {{- end}}
        io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
        #io.rancher.sidekicks: kopf
  kopf:
    image: lmenezes/elasticsearch-kopf
    environment:
      KOPF_ES_SERVERS: elasticsearch:9200
      KOPF_SERVER_NAME: _
    links:
      - elasticsearch:elasticsearch
    {{- if ne .Values.elasticsearch_port "" }}
    ports:
      - ${elasticsearch_port}:80
    {{- end}}
    stdin_open: true
    tty: true
    labels:
        io.rancher.container.pull_image: always
  graylog:
    image: "graylog2/server:2.3.2-2"
    stdin_open: true
    tty: true
    environment:
      TZ: ${graylog_timezone}
      GRAYLOG_ROOT_TIMEZONE: ${graylog_timezone}
      GRAYLOG_ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      GRAYLOG_PASSWORD_SECRET: ${graylog_secret}
      GRAYLOG_ROOT_PASSWORD_SHA2: ${graylog_password}
      GRAYLOG_WEB_ENDPOINT_URI: "${graylog_url}"
    labels:
      io.rancher.sidekicks: geoip-data
      {{- if ne .Values.graylog_server_host_label "" }}
      io.rancher.scheduler.affinity:host_label: ${graylog_server_host_label}
      {{- end}}
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
    volumes:
      - graylog-journal-volume:/usr/share/graylog/data/journal
    volumes_from:
      - geoip-data
    links:
      - elasticsearch:elasticsearch
      - mongo:mongo
    ports:
    {{- if ne .Values.graylog_port "" }}
      - ${graylog_port}:9000
    {{- end}}
      - 12201:12201/udp
      - 12201:12201/tcp
      - 1514:1514/udp
  geoip-data:
    image: tkrs/maxmind-geoipupdate
    stdin_open: true
    tty: true
    volumes:
      - /usr/share/graylog/data/geoip
    environment:
      GEOIP_DB_DIR: '/usr/share/graylog/data/geoip/'
      {{- if ne .Values.https_proxy "" }}
      https_proxy: ${https_proxy}
      {{- end}}
    labels:
      io.rancher.container.pull_image: always
{{- if eq .Values.enable_logspout "true" }}
  logspout:
    image: flaccid/logspout:gelf
    stdin_open: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    tty: true
    environment:
      INACTIVITY_TIMEOUT: 1m
    command:
      - "gelf://graylog:12201"
    links:
      - graylog:graylog
    labels:
      io.rancher.container.pull_image: always
      io.rancher.scheduler.global: 'true'
{{- end }}
{{- if eq .Values.volumes_external "true" }}
volumes:
  graylog-journal-volume:
    external: true
  graylog-mongo-volume:
    external: true
  graylog-elasticsearch-volume:
    external: true
  graylog-geodata-volume:
    external: true
{{- end }}
