#!/bin/bash

set -e

# Initialize
echo "FAILURE" > status.txt

on_exit() {
    pkill -2 -P $$
    sleep 5
    pkill -15 -P $$
    sleep 5

    echo "========================================"
    [ -e ./status.txt ] || cat ../status.txt 
    [ -e ../status.txt ] || cat ./status.txt 
}

trap on_exit EXIT

# Clone stuff
if [ ! -e stuff ]; then
    git clone --depth 1 git://git.openembedded.org/openembedded-core stuff/openembedded-core
    git clone --depth 1 git://git.openembedded.org/bitbake stuff/openembedded-core/bitbake
    git clone --depth 1 git://git.openembedded.org/meta-openembedded stuff/meta-openembedded
    git clone --depth 1 git://github.com/dominiquehunziker/meta-ros stuff/meta-ros -b rebased-pull-request-519
fi

# Initialize environment
. stuff/openembedded-core/oe-init-build-env
cp ../src/bblayers.conf conf/

# Build image
MACHINE=qemuarm bitbake ros-sdk-test

# Build SDK
MACHINE=qemuarm bitbake ros-sdk-test -c populate_sdk

# Build docker image containing SDK
cp tmp-glibc/deploy/sdk/*.sh  ../src/docker/toolchain.sh
docker build -t ros-sdk-test ../src/docker

# Generate binaries for target system using the SDK docker image
[ -e sdk-output ] || mkdir sdk-output
docker run --rm -v `pwd`/sdk-output:/root/output ros-sdk-test

# Launch qemu
runqemu tmp-glibc/deploy/images/qemuarm/ros-sdk-test-qemuarm.qemuboot.conf slirp qemuparams=-snapshot &
sleep 30  # Wait a bit for the image to boot

ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2222
scp -P 2222 -o StrictHostKeyChecking=no ../status.txt root@localhost:/home/root/

# Copy generated binaries and stuff for compiling on target
scp -P 2222 `pwd`/sdk-output/data.tar root@localhost:/home/root
scp -P 2222 -r ../src/target root@localhost:/home/root/src

# Run script on target
ssh -p 2222 root@localhost /home/root/src/run.sh
scp -P 2222 root@localhost:/home/root/status.txt ../
