#!/bin/bash

set -x

export JENKINS_URL="http://127.0.0.1:8080"
JAVA=/usr/bin/java


# HOME
if [ -z "$HOME" ]
then
  echo HOME not in environment, guessing...
  export HOME=$(awk -F: -v v="$USER" '{if ($1==v) print $6}' /etc/passwd)
fi

# WORKSPACE
cd $WORKSPACE
mkdir -p ../android
cd ../android
export OLDWORKSPACE=$WORKSPACE
export WORKSPACE=$PWD
export

#HUDSON
if [ ! -d hudson ]
then
  git clone https://github.com/KFireHDX/hudson.git -b master
fi
cd hudson
## Get rid of possible local changes
git reset --hard
git pull -s resolve
cd ..

rm -f jenkins-cli.jar
wget ${JENKINS_URL}/jnlpJars/jenkins-cli.jar

grep -v -e "^#" -e "^$" hudson/kfirehdx-build-targets | while read ROWS}; do
  arrrow=(${ROWS// / })
  FREQUENCY="${arrrow[2]}
  [[ -z $FREQUENCY ]] && FREQUENCY=N
    JOB_FREQUENCY=N
  if [ "$FREQUENCY" == "$JOB_FREQUENCY" ]; then
      $JAVA -jar jenkins-cli.jar build kfirehdx -p RELEASE_TYPE=${arrrow[1]} -p LUNCH=${arrrow[0]}
  fi
done
