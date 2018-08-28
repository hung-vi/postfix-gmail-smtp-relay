FROM ubuntu:16.04

# setup
ADD ./files/etc/profile /etc/profile
ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND noninteractive

# install necessary packages. Postfix is a dependency of mailutils
RUN apt-get update && \
    apt-get install -y vim supervisor \
    rsyslog \
    mailutils


# Log
COPY    ./files/conf/supervisord.conf /etc/supervisord.conf
COPY    ./files/conf/rsyslog/rsyslog.conf /etc/rsyslog.conf
COPY    ./files/conf/rsyslog/rsyslog.d /etc/rsyslog.d

COPY    ./files/etc/postfix/sasl_passwd /etc/postfix/sasl_passwd
RUN chmod 600 /etc/postfix/sasl_passwd

RUN postconf compatibility_level=2;
RUN postconf -e 'relayhost = [smtp.gmail.com]:587'
RUN postconf -e 'smtp_use_tls = yes'
RUN postconf -e 'smtp_sasl_auth_enable = yes'
RUN postconf -e 'smtp_sasl_security_options ='
RUN postconf -e 'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd'

RUN postmap /etc/postfix/sasl_passwd


# Start postfix service
ADD ./files/conf/startservices.sh /startservices.sh
RUN chmod og+x /startservices.sh

# Start services
ENTRYPOINT [ "sh", "-c", "/startservices.sh" ]
