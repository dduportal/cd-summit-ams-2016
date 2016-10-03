FROM jenkins:2.7.4-alpine
MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat /tmp/plugins.txt)
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

COPY ./id_rsa /ssh-keys/id_rsa
USER root
RUN chmod 0400 /ssh-keys/* \
  && chown -R jenkins:jenkins /ssh-keys/*
USER jenkins

COPY ./init.groovy.d /usr/share/jenkins/ref/init.groovy.d
