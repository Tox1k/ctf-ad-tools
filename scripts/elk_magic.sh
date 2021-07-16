#!/bin/bash

sudo apt-get update -y
sudo apt-get install openjdk-8-jdk-headless htop -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install kibana elasticsearch logstash
mkdir install && cd install
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.3-linux-x86_64.tar.gz -O elasticsearch-7.13.3-linux-x86_64.tar.gz
tar zxvf elasticsearch-7.13.3-linux-x86_64.tar.gz
cd ..
mkdir src && cd src
wget https://github.com/elastic/elasticsearch/archive/v7.13.3.tar.gz -O elasticsearch-v7.13.3.tar.gz
tar zxvf elasticsearch-v7.13.3.tar.gz
cd ..
mkdir build && cd build
ln -s ../install/elasticsearch-7.13.3/lib .
ln -s ../install/elasticsearch-7.13.3/modules .
find ../src -name "License.java" | xargs -r -I {} cp {} .
sed -i 's#this.type = type;#this.type = "platinum";#g' License.java
sed -i 's#validate();#// validate();#g' License.java
javac -cp "`ls lib/elasticsearch-7.13.3.jar`:`ls lib/elasticsearch-x-content-7.13.3.jar`:`ls lib/lucene-core-*.jar`:`ls modules/x-pack-core/x-pack-core-7.13.3.jar`" License.java
mkdir src && cd src
find ../../install -name "x-pack-core-7.13.3.jar" | xargs -r -I {} cp {} .
jar xvf x-pack-core-7.13.3.jar
rm -f x-pack-core-7.13.3.jar
\cp -f ../License*.class org/elasticsearch/license/
jar cvf x-pack-core-7.13.3.jar .
sudo cp x-pack-core-7.13.3.jar /usr/share/elasticsearch/modules/x-pack-core/
sudo sed -i '$a\xpack.security.enabled: true\nxpack.security.transport.ssl.enabled: true\n' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '$a\elasticsearch.username: kibana\nelasticsearch.password: changeme\n' /etc/kibana/kibana.yml
sudo systemctl enable --now elasticsearch.service
sudo systemctl enable --now kibana.service
sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
#basically just spam changeme
sudo systemctl restart elasticsearch.service
sudo systemctl restart kibana.service
