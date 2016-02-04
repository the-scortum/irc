FROM       ubuntu:14.04
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive

# http://blog.khairulazam.net/2012/12/17/install-unrealircd-on-ubuntu-12-04/
RUN apt-get update && apt-get -y upgrade; \
    apt-get install -y vim emacs; \
    apt-get install -y gcc g++ make wget build-essential;  \
    apt-get install -y openssl debconf libc6 libcomerr2 libcurl3 libidn11 zlib1g libssl-dev; \
    apt-get install -y openssh-server supervisor

RUN mkdir -p /var/run/sshd /var/log/supervisor

# TODO: Enable cleanup once everything works :-)
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*


RUN  adduser  ircd
USER    ircd
WORKDIR /home/ircd

COPY src/Unreal3.2.4.tar.gz /home/ircd/Unreal.3.2.4.tar.gz
COPY src/unrealircd.conf    /home/ircd/Unreal3.2/unrealircd.conf

RUN  cd /home/ircd &&  \
     tar -zxf Unreal.3.2.4.tar.gz && \
     chown -R ircd:ircd /home/ircd

# Switch from user root to user ircd:
RUN  cd /home/ircd/Unreal3.2 && ./Config
RUN  cd /home/ircd/Unreal3.2 && make
RUN  cd /home/ircd && ln -s /home/ircd/Unreal3.2 leaf
RUN  cd /home/ircd/Unreal3.2 &&  \
     touch ircd.log ircd.motd ircd.rules

USER root
COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 22, 6999
COPY   src/run.sh /run.sh
CMD    "/run.sh"

