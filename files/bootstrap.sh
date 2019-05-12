#!/bin/bash
sudo sysctl -w net.ipv4.ip_forward=1
# sudo iptables -t nat -A OUTPUT -o lo -p tcp --dport 80 -j REDIRECT --to-port 5050
# sudo iptables -I INPUT 1 -p tcp --dport 8443 -j ACCEPT
# sudo iptables -I INPUT 1 -p tcp --dport 5050 -j ACCEPT
# sudo iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT
# sudo iptables -I INPUT 1 -p tcp --dport 443 -j ACCEPT
# sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
# sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
# sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8443
# sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 5050


sudo apt update -y 
sudo apt install firewalld -y 
sudo apt install python3-pip  -y 
sudo apt install emacs -y 
sudo apt install ffmpeg -y 
sudo apt install supervisor -y 



##
sudo firewall-cmd --add-port=80/tcp --permanent  
sudo firewall-cmd --add-port=443/tcp --permanent  
sudo firewall-cmd --add-forward-port=port=80:proto=tcp:toaddr=0.0.0.0:toport=5050 --permanent
sudo firewall-cmd --add-forward-port=port=443:proto=tcp:toaddr=127.0.0.1:toport=8443 --permanent
sudo firewall-cmd --reload






## 

python3 -m pip install pipenv

PROCESSOR_DIR=$HOME/processor 
rm -rf $PROCESSOR_DIR
git clone https://github.com/joshlong/podcast-production-pipeline-ffmpeg.git $PROCESSOR_DIR

cd $PROCESSOR_DIR 

cat $HOME/env.sh 

source $HOME/env.sh

python3 -m pipenv install
python3 -m pipenv run python ${PROCESSOR_DIR}/config_aws.py $HOME/.aws/
# python3 -m pipenv run python main.py

 
cd service
SVC_DIR=$(pwd)
SVC_ENV=${PROCESSOR_DIR}/service/processor-environment.sh
SVC_INIT=${PROCESSOR_DIR}/service/processor-service.sh

cat $HOME/env.sh >> ${SVC_ENV}


${SVC_DIR}/install.sh 

# sudo cp ${SVC_DIR}/supervisor.conf /etc/supervisor/supervisord.conf
