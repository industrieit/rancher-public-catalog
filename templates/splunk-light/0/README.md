# Splunk Light

*This is an unofficial package of Splunk Light.*

## Info
Splunk is a log aggregation and analysis tool in the Operational Intelligence space.

This template includes an unofficial docker image of Splunk Light and the official image of a universal forwarder.

## Usage
Licence;

- This template automatically accepts Splunk's licence agreement.
- Launching this template is your acceptance of Splunk's licence agreement.  You have been warned. :)

Volumes;

- To save data outside of the container and host, a volume should be mounted at /opt/splunk on the host running the splunk search head/indexer.
- Without a separately mounted volume splunk data (config and logging) will be lost when the supporting host is terminated.

Deployment Server;

- The Splunk server is also configured to be a Splunk deployment server.
- The Splunk Universal Forwarder is registered with the deployment server.

Credentials;

- The default UI login credentials are admin/changeme.
- This can be changed on the LHS menu > Settings > Manage Accounts page.

Options;

1. Publish Splunk UI Port
  - Allows direct access to the Splunk UI if set true.
  - If set to false a load balancer is expected to point at the exposed Splunk port 8000.
  - When set to true the published port can be chosen.  This is mapped back to the container port of 8000.
2. Host Affinity
  - Control the hosts on which selenium will run.
  - When blank Splunk will run on any available host in the environment.


## Documentation
More detailed documentation can be found at [github yugesha](https://github.com/yugesha/docker-splunk) and [github splunk](https://github.com/splunk/docker-splunk), [docker yugeshdocker1](https://hub.docker.com/r/yugeshdocker1/docker-splunk-light/) and [docker splunk](https://hub.docker.com/r/splunk/splunk/), and the [splunk website](https://www.splunk.com/en_us/products/splunk-light.html)
