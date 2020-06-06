FROM ubuntu:18.04
WORKDIR /com
RUN apt-get update && apt-get install -y ansible unzip
RUN wget https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip \
	&& unzip vault_1.4.2_linux_amd64.zip \
	&& mv vault /usr/local/bin
COPY com /usr/local/bin/com
COPY VERSION /VERSION
ENTRYPOINT ["/usr/local/bin/com"]
