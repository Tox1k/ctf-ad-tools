#!/bin/bash

if (( $# != 1 )); then
    >&2 echo "Illegal number of parameters"
    exit
fi

generate_conf() {
    PAIR=$1

    NAME=$(echo $PAIR | awk -F, '{print $1}')
    ENDPOINT_ADDR=$(echo $PAIR | awk -F, '{print $2}')
    wg genkey | tee $NAME.key | wg pubkey > $NAME.pub
    PUB_KEY=$(cat $NAME.pub)
    KEY=$(cat $NAME.key)
    IP=$(expr $i + 100)
    i=$(expr $i + 1)
    echo $KEY $NAME $IP

    echo '[Interface]' > wg-$NAME.conf
    echo "Address = 10.6.6.$IP/24" >> wg-$NAME.conf
    echo "PrivateKey = ${KEY}" >> wg-$NAME.conf
    echo 'ListenPort = 51820' >> wg-$NAME.conf
    
    echo '[Peer]' >> wg-$NAME.conf
    echo "PublicKey = ${ROUTER_PUB_KEY}" >> wg-$NAME.conf
    echo "Endpoint = ${ROUTER_IP}:51820" >> wg-$NAME.conf
    echo 'AllowedIPs = 10.6.6.0/24' >> wg-$NAME.conf
    echo 'PersistentKeepalive = 25' >> wg-$NAME.conf

    echo '' >> $ROUTER_CONF_NAME
    echo '[Peer]' >> $ROUTER_CONF_NAME
    echo "PublicKey = ${PUB_KEY}"  >> $ROUTER_CONF_NAME
    echo "Endpoint = ${ENDPOINT_ADDR}:51820" >> $ROUTER_CONF_NAME
    echo "AllowedIPs = 10.6.6.${IP}/32" >> $ROUTER_CONF_NAME
    echo 'PersistentKeepalive = 25' >> $ROUTER_CONF_NAME
}

ROUTER_IP=$(grep router /etc/hosts | awk '{print $1}')

echo "Router IP = ${ROUTER_IP}"

if [[ -f "wg-router.conf" ]] 
then
    ROUTER_CONF_NAME=ADD_TO_wg-router.conf
else
    ROUTER_CONF_NAME=wg-router.conf
    touch $ROUTER_CONF_NAME
    wg genkey | tee router.key | wg pubkey > router.pub
    ROUTER_PUB_KEY=$(cat router.pub)
    ROUTER_KEY=$(cat router.key)

    echo '[Interface]' > wg-router.conf
    echo "Address = 10.6.6.1/24" >> wg-router.conf
    echo "PrivateKey = ${ROUTER_KEY}" >> wg-router.conf
    echo 'ListenPort = 51820' >> wg-router.conf
fi
    

i=1
for PAIR in $(cat $1)
do
    generate_conf $PAIR
done

OWN_IP=$(wget -O - v4.ident.me 2>/dev/null && echo)

generate_conf "$(whoami),${OWN_IP}"
