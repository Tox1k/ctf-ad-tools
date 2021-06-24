#!/bin/bash

sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:oisf/suricata-stable -y
sudo apt-get update -y 
sudo apt-get install suricata -y
