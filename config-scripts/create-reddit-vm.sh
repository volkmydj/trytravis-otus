#!/bin/bash
### Create GCP instance
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family reddit-full \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \


### Create GCP firewall rules
  gcloud compute firewall-rules create default-puma-server\
  --allow tcp:9292 \
  --target-tags=puma-server \
  --source-ranges 0.0.0.0/0 \
  --priority 1000
