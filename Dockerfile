FROM ubuntu
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade;  \
    apt-get install -y vim emacs


# http://blog.khairulazam.net/2012/12/17/install-unrealircd-on-ubuntu-12-04/
RUN apt-get update && apt-get -y upgrade; \
    apt-get install -y gcc g++ make wget build-essential

RUN apt-get install -y openssl debconf libc6 libcomerr2 libcurl3 libidn11 zlib1g libssl-dev

RUN adduser ircd
WORKDIR /home/ircd

# USER ircd

RUN wget https://www.unrealircd.org/unrealircd4/unrealircd-4.0.1.tar.gz  && \
    gpg --keyserver keys.gnupg.net --recv-keys 0xA7A21B0A108FF4A9  &&  \
    wget https://www.unrealircd.org/unrealircd4/unrealircd-4.0.1.tar.gz.asc  && \
    tar -zxf unrealircd-4.0.1.tar.gz  && \
    ln -s unrealircd-4.0.1 unrealircd 

RUN cd unrealircd && \
    ./Config  && \
    make  &&  \
    make install 



# https://help.ubuntu.com/lts/serverguide/irc-server.html
#    apt-get install -y ircd-irc2


# TODO: Enable cleanup once everything works :-)
#  && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*


EXPOSE 6999

ADD src/run.sh /run.sh
CMD "/run.sh"

