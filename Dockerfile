FROM       ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade; \
    apt-get install -y vim emacs; \
    apt-get install -y gcc g++ make wget build-essential; \
    apt-get install -y openssl debconf libc6 libcomerr2 \
                       libcurl3 libidn11 zlib1g libssl-dev; \
    apt-get install -y openssh-server supervisor; \
    mkdir -p /var/run/sshd /var/log/supervisor; \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN      adduser  ircd
COPY     src/Unreal3.2.4.tar.gz /home/ircd/Unreal.3.2.4.tar.gz
USER     ircd
WORKDIR  /home/ircd
RUN      cd /home/ircd            &&  tar -zxf Unreal.3.2.4.tar.gz
RUN      cd /home/ircd/Unreal3.2  &&  ./Config
RUN      cd /home/ircd/Unreal3.2  &&  make
RUN      cd /home/ircd            &&  ln -s /home/ircd/Unreal3.2 leaf
RUN      cd /home/ircd/Unreal3.2  &&  touch ircd.log ircd.motd ircd.rules


EXPOSE  22 6990-7000

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD     ["/home/ircd/leaf/unreal", "start"]

