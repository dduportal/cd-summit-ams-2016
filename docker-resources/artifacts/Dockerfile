FROM jfrog-docker-reg2.bintray.io/jfrog/artifactory-oss:latest
MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

# Install Tini
ENV TINI_VERSION=0.10.0 \
  TINI_SHA1SUM=7d00da20acc5c3eb21d959733917f6672b57dabb
RUN curl -L -o /tmp/tini-static \
  "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static" \
  && echo "${TINI_SHA1SUM}  /tmp/tini-static" | sha1sum -c - \
  && mv /tmp/tini-static /sbin/tini \
  && chmod a+x /sbin/tini

COPY setup-artifactory.sh /app/setup-artifactory.sh
COPY artifactory.config.xml /app/artifactory.config.xml
COPY local-m2-cache /local-m2-cache
RUN echo 'export START_TMO=600' >> /etc/opt/jfrog/artifactory/default
RUN sh -c /app/setup-artifactory.sh
RUN rm -f /var/opt/jfrog/run/*

ENTRYPOINT ["/sbin/tini","-g","/tmp/run.sh"]
