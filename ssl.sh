#!/bin/bash
if [ $1 == '-i' ]
then
    # install dehydrated
    mkdir -p /etc/dehydrated/
    wget https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated -O /etc/dehydrated/dehydrated
    chmod 755 /etc/dehydrated/dehydrated
    # setting dehydrated
    echo "WELLKNOWN=/var/www/dehydrated" > /etc/dehydrated/config
    mkdir -p /var/www/dehydrated
    /etc/dehydrated/dehydrated --register --accept-terms
elif [ $1 == '-c' ]
then
    if [ -z $2 ]
    then
        echo 'Please enter domain name'
    else
        set -f
        array=(${2//./ })
        cp default.conf /etc/nginx/conf.d/${array[0]}.conf
        sed -i -e 's/default.domain.com/'$2'/g' /etc/nginx/conf.d/$2.conf
        service nginx restart
        /etc/dehydrated/dehydrated -c -d $2
        sed -i -e '/# DEL_START/,/# DEL_END/d' /etc/nginx/conf.d/$2.conf
        sed -i -e 's/#//g' /etc/nginx/conf.d/$2.conf
        service nginx restart
    fi
fi
