FROM ubuntu:14.04
MAINTAINER jerome.petazzoni@docker.com

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
    
# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]

# Install make.
RUN  apt-get update -qq && apt-get install build-essential -qqy
RUN make --version

# Install golang.
RUN curl -o /tmp/go.tar.gz https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
RUN tar -xzf /tmp/go.tar.gz -C /opt
RUN ln -s /opt/go/bin/go /usr/bin/go
RUN go version
ENV GOROOT=/opt/go

# Install PIP.
RUN curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python3 /tmp/get-pip.py --user
RUN ln -s /root/.local/bin/pip /usr/bin/pip
RUN pip --version

# Install AWS CLI.
RUN pip install --upgrade --user awscli
RUN ln -s /root/.local/bin/aws /usr/bin/aws
RUN aws --version
