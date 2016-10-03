FROM gogs/gogs@sha256:f206e8bcc77c8577fe1c4a94e59fe3a3a0ddb8e0f8f4fa6cf4a88d241c645d20
MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

# Install Tini
ENV TINI_VERSION=0.10.0 \
  TINI_SHA1SUM=7d00da20acc5c3eb21d959733917f6672b57dabb
RUN curl -L -o /tmp/tini-static \
  "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static" \
  && echo "${TINI_SHA1SUM}  /tmp/tini-static" | sha1sum -c - \
  && mv /tmp/tini-static /sbin/tini \
  && chmod a+x /sbin/tini

COPY entrypoint.sh /app/entrypoint.sh
COPY setup-gogs.sh /app/setup-gogs.sh
COPY app.ini.tpl /app/app.ini.tpl

ENTRYPOINT ["/sbin/tini","-g","bash","/app/entrypoint.sh"]
