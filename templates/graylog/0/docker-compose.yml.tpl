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
    stdin_open: true
    tty: true
    labels:
        io.rancher.container.pull_image: always
  graylog:
    image: "graylog2/server:2.3.1-1"
    stdin_open: true
    tty: true
    environment:
      TZ: Australia/Sydney
      GRAYLOG_ROOT_TIMEZONE: Australia/Sydney
      GRAYLOG_ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      GRAYLOG_PASSWORD_SECRET: ${graylog_secret}
      GRAYLOG_ROOT_PASSWORD_SHA2: ${graylog_password}
      GRAYLOG_WEB_ENDPOINT_URI: "http://${graylog_fqdn}:9000/api"
    labels:
      #io.rancher.sidekicks: geoip-data
      {{- if ne .Values.graylog_server_host_label "" }}
      io.rancher.scheduler.affinity:host_label: ${graylog_server_host_label}
      {{- end}}
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
    volumes:
      - graylog-plugin-volume:/usr/share/graylog/data/plugin
      - graylog-geodata-volume:/usr/share/graylog/data/geoip
    links:
      - elasticsearch:elasticsearch
      - mongo:mongo
    ports:
      - 12201:12201/udp
      - 12201:12201/tcp
      - 1514:1514/udp
  geoip-data:
    image: tkrs/maxmind-geoipupdate
    stdin_open: true
    tty: true
    volumes:
      - graylog-geodata-volume:/usr/share/graylog/data/geoip
    environment:
      GEOIP_DB_DIR: '/usr/share/graylog/data/geoip/'
      {{- if ne .Values.https_proxy "" }}
      https_proxy: ${https_proxy}
      {{- end}}
    labels:
      io.rancher.container.pull_image: always
  graylog-lb:
    image: rancher/lb-service-haproxy:v0.7.6
    ports:
     - ${graylog_lb_port}:${graylog_lb_port}
     - 9001:9001
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: 'true'
      io.rancher.scheduler.global: 'true'
      {{- if ne .Values.lb_host_label "" }}
      io.rancher.scheduler.affinity:host_label: ${lb_host_label}
      {{- end}}
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
volumes:
  graylog-mongo-volume:
    driver: ${mongodb_volume_driver}
    {{- if eq .Values.mongodb_volume_driver_external "true" }}
    external: true
    {{- else }}
    per_container: true
    {{- end }}
    {{- if eq .Values.mongodb_volume_driver "rancher-azdisk" }}
    driver_opts:
      size: "16"
      volumeType: "Standard_LRS"
    {{- end }}
  graylog-plugin-volume:
    driver: ${graylog_volume_driver}
    {{- if eq .Values.graylog_volume_driver_external "true" }}
    external: true
    {{- else }}
    per_container: true
    {{- end }}
    {{- if eq .Values.graylog_volume_driver "rancher-azurefile" }}
    driver_opts:
      delete_on_terminate: true
      uid: 1100
      gid: 1100
    {{- end }}
  graylog-geodata-volume:
    driver: ${graylog_volume_driver}
    {{- if eq .Values.graylog_volume_driver_external "true" }}
    external: true
    {{- else }}
    per_container: true
    {{- end }}
    {{- if eq .Values.graylog_volume_driver "rancher-azurefile" }}
    driver_opts:
      delete_on_terminate: true
      uid: 1100
      gid: 1100
    {{- end }}
  graylog-elasticsearch-volume:
    driver: ${elasticsearch_volume_driver}
    {{- if eq .Values.elasticsearch_volume_driver_external "true" }}
    external: true
    {{- else }}
    per_container: true
    {{- end }}
    {{- if eq .Values.elasticsearch_volume_driver "rancher-azdisk" }}
    driver_opts:
      size: ${elasticsearch_volume_size}
      volumeType: "Standard_LRS"
    {{- end }}
