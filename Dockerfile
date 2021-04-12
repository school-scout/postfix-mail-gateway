FROM debian:stable

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install postfix python-minimal \
 && rm -fR /var/lib/apt/lists/*

COPY syslog-stdout.py /usr/local/bin/syslog-stdout.py
COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
EXPOSE 25/tcp
