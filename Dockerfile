# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
#FROM phusion/baseimage:0.9.11
FROM ubuntu:14.10

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.

# ...put your own build instructions here...
# based on mzkrelx / playframework2-dev

EXPOSE 9000

ENV PLAY_VERSION 2.2.2
ENV PATH $PATH:/opt/play-$PLAY_VERSION


RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install unzip git -y
RUN apt-get install --no-install-recommends -y openjdk-8-jdk

ADD http://downloads.typesafe.com/play/$PLAY_VERSION/play-$PLAY_VERSION.zip /tmp/play-$PLAY_VERSION.zip
RUN (cd /opt && unzip /tmp/play-$PLAY_VERSION.zip && rm -f /tmp/play-$PLAY_VERSION.zip)

# adding an unique file just so that the git pull command is not cached
ADD http://www.random.org/strings/?num=10&len=8&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new uuid

RUN (cd /opt && git clone https://github.com/tcarlyle/emht.git)

RUN cd /opt/emht  && git pull
RUN cd /opt/emht  && play clean stage
CMD [ "/opt/emht/target/universal/stage/bin/emht -DapplyEvolutions.default=true"]


