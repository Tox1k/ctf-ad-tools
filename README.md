# docker-stuff-ad

## caronte

ip: http://172.16.2.2:3333


## netdata

ip: http://172.16.1.2:19999


## Per chi vuole accedere ai servizi via grafica comodamente da browser:

**flag submitter**
`ssh -L 127.0.0.1:9000:172.16.3.2:8080 root@<indirizzo-macchina>`

**netdata**
`ssh -L 127.0.0.1:19999:172.16.1.2:19999 root@<indirizzo-macchina>`

**caronte**
`ssh -L 127.0.0.1:3333:172.16.2.2:3333 root@<indirizzo-macchina>`

## Suricata how to:

1. Installare Suricata dallo script ./scripts/install_suricata.sh
2. Modificare il file /etc/suricata/suricata.yaml:
    - cercare `copy-mode` e decommentare la riga in questione
    - specificato l'interfaccia su cui avere l'ips mode (wg-vulnbox)
    - cercare `suricata.rules`
    - specificare come file di regole `template.rules` (NB non copiare il file di questo repo, utilizzarlo solo come base per le regole da scrivere)
3. Eseguire  `./scripts/iptables_suricata.sh`
4. Modificare ogni docker-compose, specificando un indirizzo statico, in modo che se viene riavviato il container, il servizio non cambi IP
5. `mkdir -p /var/lib/suricata/rules`
6. `suricata -k none -c /etc/suricata/suricata.yaml` per caricare nuove regole (NB **MAI** interrompere il processo di suricata per troppo tempo, altrimenti i servizi vanno giù)

## Credits
Original repo:
[https://git.fuo.fi/fuomag9/docker-stuff-ipv6-ad/](https://git.fuo.fi/fuomag9/docker-stuff-ipv6-ad)
