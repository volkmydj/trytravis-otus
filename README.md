# volkmydj_infra
bastion_IP = 35.225.27.208
someinternalhost_IP = 10.132.0.7


# Create GCP instance with startup script #
<gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=gs://avolkov-otus/startup_script.sh>

# Create GCP firewall rules #

gcloud compute firewall-rules create default-puma-server\
  --allow tcp:9292 \
  --target-tags=puma-server

# Test connections to reddit app

testapp_IP = 35.205.164.130
testapp_port = 9292
