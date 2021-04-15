#!/bin/bash

if [ "$1" = "off" ] ;
then cp /tmp/nginx-conf-autoindex-off /etc/nginx/sites-available/raccoman ;
else cp /tmp/nginx-conf /etc/nginx/sites-available/raccoman ; fi
service nginx reload
