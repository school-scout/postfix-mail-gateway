FROM debian:jessie

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postfix

RUN bash -c \
  'FILES="localtime services resolv.conf hosts nsswitch.conf"; \
  for file in $FILES; do  \
      cp /etc/${file} /var/spool/postfix/etc/${file}; \
      chmod a+rX /var/spool/postfix/etc/${file} \
      ; \
  done'
COPY syslog-stdout.py /usr/local/bin/syslog-stdout.py
COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
EXPOSE 25/tcp
