FROM ubuntu:trusty
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y zookeeper
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN sed -i 's/ROLLINGFILE/CONSOLE/' /etc/zookeeper/conf/environment
ADD zook_start.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/zook_start.sh
ENTRYPOINT ["/usr/local/bin/zook_start.sh"]
CMD ["start-foreground"]
