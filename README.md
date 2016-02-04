# irc



Run multiple things in one container:

* [Using Supervisor with Docker](https://docs.docker.com/engine/articles/using_supervisord/)


## Runs:

* supervisord with:
  * unrealirc
  * sshd


## Systemd:

    /etc/default/docker

    # Docker Upstart and SysVinit configuration file
    
    # Customize location of Docker binary (especially for development testing).
    #DOCKER="/usr/local/bin/docker"
    
    # Use DOCKER_OPTS to modify the daemon startup options.
    #DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"
    
    # If you need Docker to use an HTTP proxy, it can also be specified here.
    #export http_proxy="http://127.0.0.1:3128/"
    
    # This is also a handy place to tweak where Docker's temporary files go.
    #export TMPDIR="/mnt/bigdrive/docker-tmp"



    /lib/systemd/system/docker.service

    [Unit]
    Description=Docker Application Container Engine
    Documentation=https://docs.docker.com
    After=network.target docker.socket
    Requires=docker.socket
    
    [Service]
    Type=notify
    ExecStart=/usr/bin/docker daemon -H fd://
    MountFlags=slave
    LimitNOFILE=1048576
    LimitNPROC=1048576
    LimitCORE=infinity
    
    [Install]
    WantedBy=multi-user.target





