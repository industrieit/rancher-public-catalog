# Prometheus-client

### Info:

This template deploys a collection of monitoring agents that export data via a HTTP endpoint.  This data can then be imported by a Prometheus server.

### cAdvisor

Exports container statistics

### node-exporter

Exports node statistics

## Deployment:
1. Select Prometheus-client from the community catalog.
2. Click deploy.

## Usage
* Prometheus can be set to pull data using DNS based discovery.  Setup a DNS updater to keep a DNS record updated with the IPs of the prometheus client nodes and configure Prometheus to use this DNS entry as a scrape target.
