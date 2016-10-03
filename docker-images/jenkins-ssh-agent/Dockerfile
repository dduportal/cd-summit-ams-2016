FROM alpine:3.4
MAINTAINER MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

RUN apk add --update --no-cache \
  bash \
  curl \
  git \
  openjdk8 \
  openssh \
  openssh-client

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
  MVN_VERSION=3.3.9 \
  PATH=/opt/apache-maven-3.3.9/bin:${PATH}
RUN curl -fSL "http://apache.belnet.be/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz" -o /tmp/maven.tgz \
  && mkdir -p /opt \
  && tar xzf /tmp/maven.tgz -C /opt \
  && rm -rf /tmp/maven.tgz

ARG HOME
ENV HOME ${HOME}
RUN mkdir -p ${HOME} /var/run/sshd \
  && addgroup -g 1000 jenkins \
  && adduser -h ${HOME} -s /bin/bash -G jenkins -D -u 1000 jenkins \
  && passwd -u jenkins \
  && echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config \
  && echo 'RSAAuthentication yes' >> /etc/ssh/sshd_config \
  && echo 'Banner none' >> /etc/ssh/sshd_config \
  && echo 'UseDNS no' >> /etc/ssh/sshd_config \
  && echo 'PrintMotd no' >> /etc/ssh/sshd_config \
  && echo 'LogLevel quiet' >> /etc/ssh/sshd_config \
  && touch ${HOME}/.hushlogin \
  && chown -R jenkins:jenkins ${HOME} \
  && ssh-keygen -A
VOLUME ${HOME}
WORKDIR ${HOME}

COPY ./setup-sshd.sh /usr/local/bin/setup-sshd.sh
COPY ./settings.xml /opt/apache-maven-3.3.9/conf/settings.xml

EXPOSE 22

ENTRYPOINT ["bash","-x","setup-sshd.sh"]
