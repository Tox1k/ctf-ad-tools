#!/bin/sh

RULE_OUT='DOCKER-USER -p tcp'
RULE_IN='DOCKER-USER -p tcp'
NFQ_ACTION='-j NFQUEUE --queue-num 0'

up(){
    iptables -I $RULE_OUT $NFQ_ACTION
    iptables -I $RULE_OUT -j LOG
    iptables -I $RULE_IN $NFQ_ACTION
    iptables -I $RULE_IN -j LOG
}


down(){
    iptables -D $RULE_OUT $NFQ_ACTION
    iptables -D $RULE_OUT -j LOG
    iptables -D $RULE_IN $NFQ_ACTION
    iptables -D $RULE_IN -j LOG
}

$1

# 1. installato suricata

# suricata.yaml
# 2. aggiunto regole template.rules
# 3. specificato l'interfaccia su cui avere l'ips mode (wg-vulnbox)
# 4. modifichiamo i dockerfile con un ip per ogni docker-compose
# 5. modificare ogni docker-compose, specificando un indirizzo statico, in modo che se viene riavviato il container, il servizio non cambi IP
