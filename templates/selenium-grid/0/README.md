# Selenium Grid

*This is an unofficial package of Selenium Grid.*

## Info
Selenium allows automated testing of browser based applications.

Selenium Grid provides a platform to execute test suites across multiple nodes supporting multiple browsers.

This template installs Selenium grid hub and nodes for Chrome and Firefox browsers.

## Usage

1. Publish Main Selenium Port
  - Allows direct access to the hub container if set true.
  - If set to false a load balancer is expected to point at the exposed hub port 4444.
  - When set to true the published port can be chosen.  This is mapped back to the container port of 4444.
2. Host Affinity
  - Control the hosts on which selenium will run.
  - When blank selenium will run on any available host in the environment.
3. Debug
  - Installs the debug versions of the nodes.
  - Not to be used for normal execution as the containers are much heavier.
  - Not to be scaled as port conflicts are likely.
  - When debug is set to true, the ports for each node type can be defined.
  - Point a VNC client at the host and port configuration (Safari has one built in).
  - When the VNC client prompts for a password use "secret" for both node types.

## Documentation
More detailed documentation can be found at [docker](https://hub.docker.com/u/selenium/), [github](https://github.com/SeleniumHQ/selenium), and [website](http://www.seleniumhq.org/)
