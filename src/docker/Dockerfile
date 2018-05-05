FROM ubuntu:16.04

# Install minimal dependencies to install SDK
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        file \
        python \
        xz-utils && \
    rm -rf /var/lib/apt/lists/

# Install SDK
ADD toolchain.sh /toolchain.sh
RUN /toolchain.sh -d /usr/local/oecore-sdk -y

# Add resources
ADD src /root/src
ADD run.sh /root/run.sh

# Automatically source the environment setup script
RUN echo "\n. /usr/local/oecore-sdk/environment-setup-*" >> /root/.bashrc

WORKDIR /root
CMD /root/run.sh
