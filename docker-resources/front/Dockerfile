FROM nginx:stable
MAINTAINER Damien DUPORTAL <dduportal@cloudbees.com>

# TUning our Nginx Configuration
COPY ./nginx-cb-conf /etc/nginx/nginx-cb-conf
COPY ./vhosts.conf /etc/nginx/conf.d/default.conf
COPY ./locations /etc/nginx/locations
COPY ./index.html /www/training/index.html
