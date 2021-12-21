# syntax=docker/dockerfile:1

FROM openjdk:11-jdk-buster

LABEL version="1.0.4"

RUN apt-get update && apt-get install -y curl unzip && \
 addgroup minecraft && \
 adduser --home /data --ingroup minecraft --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]

ENV MOTD "SkyFactory One v1.0.4 Server Powered by Docker"
ENV LEVEL world
ENV JVM_OPTS "-Xms2048m -Xmx2048m"
