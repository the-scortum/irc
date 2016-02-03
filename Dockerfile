FROM ubuntu
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade;  \
    apt-get install -y vim emacs

# https://docs.cyrus.foundation/imap/installation/distributions/ubuntu.html
RUN apt-get update && apt-get -y upgrade; \
    apt-get install -y ircd-irc2

# https://help.ubuntu.com/lts/serverguide/irc-server.html


# TODO: Enable cleanup once everything works :-)
#  && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*


EXPOSE [6999]

ADD src/run.sh /run.sh
CMD "/run.sh"

