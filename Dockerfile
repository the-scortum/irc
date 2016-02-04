FROM ubuntu:14.04
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade;  \
    apt-get install -y vim emacs


# http://blog.khairulazam.net/2012/12/17/install-unrealircd-on-ubuntu-12-04/
RUN apt-get update && apt-get -y upgrade; \
    apt-get install -y gcc g++ make wget build-essential;  \
    apt-get install -y openssl debconf libc6 libcomerr2 libcurl3 libidn11 zlib1g libssl-dev
# TODO: Enable cleanup once everything works :-)
#  && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*


RUN      adduser  ircd
WORKDIR  /home/ircd

ADD  src/unrealircd-4.0.1.tar.gz.asc   /home/ircd/unrealircd-4.0.1.tar.gz.asc
ADD  src/unrealircd.conf               /home/ircd/unrealircd/conf/unrealircd.conf
RUN  wget https://www.unrealircd.org/unrealircd4/unrealircd-4.0.1.tar.gz  && \
     gpg --keyserver keys.gnupg.net --recv-keys 0xA7A21B0A108FF4A9  &&  \
     gpg --verify unrealircd-4.0.1.tar.gz.asc unrealircd-4.0.1.tar.gz  &&  \
     tar -zxf unrealircd-4.0.1.tar.gz  &&  \
     rm unrealircd-4.0.1.tar.gz
RUN  chown -R ircd:ircd /home/ircd

# Switch from user root to user ircd:
USER ircd
RUN  cd /home/ircd/unrealircd-4.0.1 && ./Config
RUN  cd /home/ircd/unrealircd-4.0.1 && make
RUN  cd /home/ircd/unrealircd-4.0.1 && make install 

RUN cd /home/ircd/unrealircd &&  \
    touch ircd.log ircd.motd ircd.rules

EXPOSE 6999

ADD src/run.sh /run.sh
CMD "/run.sh"

