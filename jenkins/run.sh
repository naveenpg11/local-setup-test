#!/bin/sh
getent group docker || groupadd docker && usermod -aG docker jenkins \
      && chgrp docker /var/run/docker.sock
bash -x /usr/local/bin/jenkins.sh &

wait $!
