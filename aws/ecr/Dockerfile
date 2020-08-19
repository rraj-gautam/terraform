FROM alpine:latest

RUN apk add --no-cache bash clamav rsyslog wget clamav-libunrar

RUN mkdir /var/clamav
COPY conf /etc/clamav
COPY bootstrap.sh /var/clamav
#COPY check.sh /check.sh

EXPOSE 3310/tcp
VOLUME ["/var/clamav/store"]
#USER clam
CMD ["/var/clamav/bootstrap.sh"]

#HEALTHCHECK --start-period=500s CMD /check.sh
