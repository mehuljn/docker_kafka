FROM ubuntu:trusty
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y tar openjdk-7-jre-headless wget 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir  /data /logs

RUN wget -q http://www.us.apache.org/dist/kafka/0.10.1.0/kafka_2.11-0.10.1.0.tgz -O /tmp/kafka_2.11-0.10.1.0.tgz

RUN tar -zxf /tmp/kafka_2.11-0.10.1.0.tgz -C /
RUN mv /kafka_2.11-0.10.1.0 /kafka 


ADD config /kafka/config
ADD start.sh /start.sh
ADD kafka-graphite-1.0.5.jar /kafka/libs

RUN chmod 777 /start.sh

RUN groupadd kafka && \
  useradd -d /kafka -g kafka -s /bin/false kafka && \
  chown -R kafka:kafka /kafka /data /logs
USER kafka
ENV PATH /kafka/bin:$PATH
WORKDIR /kafka

VOLUME ["/data","/logs"]

# broker, jmx
EXPOSE 9092 7203

CMD ["/start.sh"]
