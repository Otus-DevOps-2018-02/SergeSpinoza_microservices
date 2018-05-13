#!/bin/bash
for (( c=1; c<=5; c++ ))
do
  docker run -d --name gitlab-runner-$c --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest

  docker exec -it gitlab-runner-$c gitlab-runner register \
    --non-interactive \
    --executor "docker" \
    --docker-image alpine:latest \
    --url "http://35.233.57.201/" \
    --registration-token "4aYbJUCGBgLR-VzANSVs" \
    --description "my-runner-$c" \
    --tag-list "linux,xenial,ubuntu,docker" \
    --run-untagged \
    --locked="false"
done
