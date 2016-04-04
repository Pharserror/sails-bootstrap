#!/bin/bash

# add ssh-key for Bitbucket project
mkdir /home/worker/.ssh
cd /home/worker/.ssh
ssh-keygen -t rsa -f worker_rsa -N '' && cat ./worker_rsa.pub | while read key; do curl --user "$BITBUCKET_USER:$BITBUCKET_PASS" --data-urlencode "key=$key" -X POST https://bitbucket.org/api/1.0/users/$BITBUCKET_USER/ssh-keys ; done
touch known_hosts
ssh-keyscan bitbucket.org >> known_hosts

cd /home/worker
# Clone the repo
git clone https://$BITBUCKET_USER:$BITBUCKET_PASS@bitbucket.org/$BITBUCKET_USER/$BITBUCKET_PROJECT.git
cd ./$BITBUCKET_PROJECT

/bin/bash -l -c 'npm install'
sudo sails lift
