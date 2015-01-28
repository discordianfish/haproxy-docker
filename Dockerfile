FROM dckr/ucarp
MAINTAINER Johannes 'fish' Ziemke <fish@freigeist.org> @discordianfish

RUN apt-get -qy update && apt-get -qy install haproxy openssl daemontools

ADD . /haproxy
WORKDIR    /haproxy
ENTRYPOINT [ "/ucarp/run", "./scripts/run" ]
