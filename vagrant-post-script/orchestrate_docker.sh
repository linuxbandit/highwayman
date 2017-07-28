#!/bin/bash

#server for multi-machine
#sudo docker run -d --restart=unless-stopped -p 80:8080 rancher/server:stable

#agent (nope, can't know beforehand)
#sudo docker run -e CATTLE_AGENT_IP="192.168.7.218"  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.5 http://192.168.7.218/v1/scripts/07065F270F7175A4760F:1483142400000:uzr4fl4qJZIQp0frHG64Rk1GBEM

#server for single machine (can work with private address)
sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
