#!/bin/bash

RUNNERS=1
URL="http://35.233.57.201/"
TOKEN="4aYbJUCGBgLR-VzANSVs"

for (( c=1; c<=$RUNNERS; c++ ))
do
  docker run -d --name gitlab-runner-$c --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest

  docker exec -it gitlab-runner-$c gitlab-runner register \
    --non-interactive \
    --executor "docker" \
    --docker-image alpine:latest \
    --url $URL \
    --registration-token $TOKEN \
    --description "my-runner-$c" \
    --tag-list "linux,xenial,ubuntu,docker" \
    --run-untagged \
    --locked="false"
done
