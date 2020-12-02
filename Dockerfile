FROM debian:buster-slim AS prepare

ENV MC_VERSION="1.16.3"
WORKDIR /papermc
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
	apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		ca-certificates \
		wget \
	\
	&& wget https://papermc.io/api/v1/paper/${MC_VERSION}/latest -O /papermc/latest

# JRE base
FROM openjdk:11.0-jre-slim
WORKDIR /papermc
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Environment variables
ENV MC_VERSION="1.16.3" \
    PAPER_BUILD="latest" \
    MC_RAM="1G" \
    JAVA_OPTS=""

RUN \
	apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
		screen \
		wget \
	\
    && rm -rf /var/lib/apt/lists/*


COPY --from=prepare /papermc/latest /papermc/latest
COPY papermc.sh /papermc.sh

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc

# Start script
CMD ["screen", "-S", "minecraft", "/papermc.sh"]
