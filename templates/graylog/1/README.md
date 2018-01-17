# Graylog

Sets up a stack with all needed for Graylog.

Important: Currently does not automatically create an input for container logs.
Once the stack is operational, login to the UI and add an Input (GELF UDP) on port 12201.

## For named volumes
Create these volumes before spinning up the stack:
* 'graylog-mongo-volume' for MongoDB
* 'graylog-elasticsearch-volume' for Elasticsearch
* 'graylog-geodata-volume' for graylog (uid 1100 / gid 1100 if using rancher-azurefile storage)
* 'graylog-journal-volume' for graylog (uid 1100 / gid 1100 if using rancher-azurefile storage)

## For bind mount volumes
* Confirm the source (or host) mount point.  Defaults to /mnt/data.

## Deployment:
1. Select Graylog from the catalog.
2. Enter the FQDN of the graylog server (used by the frontend to contact the server API)
3. Click deploy.

## Usage
* Graylog will be available on port 9000. Authentication is with the default `admin/admin`.
* Graylog also listens on ports 12201 (UDP & TCP), 5044 and 1514.
* Elasticsearch will be available, on port 80 via the Kopf web UI.
* The first step is to add a GELF UDP input (System->Inputs)
