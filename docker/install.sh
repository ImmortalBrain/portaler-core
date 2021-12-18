#!/bin/bash
source .env
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'

while true; do
    read -p "Do you wish to install the necessary packages? (y/n): " yn
    case $yn in
        [Yy]* ) apt-get update; apt-get install -y apt-transport-https ca-certificates gnupg lsb-release;
 curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;
 echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null;
 apt-get update; apt-get install -y docker-ce docker-ce-cli containerd.io;
 curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose;
 chmod +x /usr/local/bin/docker-compose; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes(y) or no(n)";;
    esac
done

mkdir user_conf.d
#curl http://example.com --output ./user_conf.d/portaler.conf

docker-compose up -d

echo -e "       ${RED}Open the link below in your browser to invite the bot to your discord server${RESTORE}"
echo -e "       ${GREEN}https://discord.com/oauth2/authorize?client_id=${DISCORD_CLIENT_TOKEN}&scope=bot&permissions=268435456${RESTORE}"

read -p $'       \e[31mType \"DONE\" when you\'ve finished inviting your bot\e[0m \n          > ' CONT
if [ "$CONT" = "DONE" ]; then
 curl -s -H "Authorization: Bearer $ADMIN_KEY" https://$SUBDOMAIN.$HOST/api/admin/list | awk -F{ '{for(i=1;i<=NF;i++){ print $i;}}';
 read -p $'\n       \e[31mPlease enter the ID of your server from the list above\e[0m \n          > ' ID
 curl -s -H "Authorization: Bearer $ADMIN_KEY" -H "Content-Type: application/json" --request POST --data "{\"id\": ${ID}, \"subdomain\": \"${SUBDOMAIN}\" }" https://$SUBDOMAIN.$HOST/api/admin/addSubdomain
 echo -e "\n       ${GREEN}Congratulations! You are done. Dont forget to give yourself the "${DISCORD_ROLE}" role on your server${RESTORE}"
fi
