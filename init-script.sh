#!/bin/bash

# optional for .env having the APP_KEY variable 
export $(grep -v '^#' ~/.env | xargs)


if [ -z "$APP_KEY" ]; then
    echo "Error: APP_KEY is not set. Please export your API key."
    exit 1
fi

response=$(curl -s --location --request GET "https://labs.hackthebox.com/api/v4/machine/active" \
  -H "Authorization: Bearer $APP_KEY")


machine_id=$(echo "$response" | jq -r '.info.id')
machine_name=$(echo "$response" | jq -r '.info.name' | tr '[:upper:]' '[:lower:]')

machine_ip=$(curl -s --location --request GET "https://labs.hackthebox.com/api/v4/machine/profile/$machine_id" -H "Authorization: Bearer $APP_KEY" | jq -r '.info.ip')

mkdir -p ~/$machine_name

host_entry="$machine_ip $machine_name.htb"

if grep -q "$machine_name.htb" /etc/hosts; then
    sudo sed -i "/$machine_name.htb/c\\$host_entry" /etc/hosts
else
    echo "Adding new entry to /etc/hosts..."
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi

sudo nmap -sC -sV -vv -oA "$HOME/$machine_name/$machine_name" $machine_name.htb