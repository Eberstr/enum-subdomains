#!/bin/bash

#Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
    
domain=$1
screenshots=$domain/screenshots

tput civis

ctrl_c(){
	echo -e "\n\n${redColour}[i] Saliendo...${endColour}\n"
	tput cnorm && exit 1
}

# ctrl_c
trap ctrl_c INT

if [ -z $domain ]; then
	echo -e "\n\n${redColour}[i] Dominio no espeficado${endColour}\n"
	exit 1
fi

# Folders creation
if [ ! -d "$domain" ]; then
	mkdir $domain
fi

if [! -d "$screenshots" ]
	mkdir $screenshots
fi

echo -e "\n\n${greenColour}[+] Enumerando con subfinder${endColour}"
echo -e "=========================="
subfinder -silent -d $domain >> $domain/subdomains.txt


echo -e "\n\n${greenColour}Enumerando con assetfinder${endColour}"
echo -e "============================"
assetfinder $domain | grep $domain >> $domain/subdomains.txt


echo -e "\n\n${greenColour}Enumerando con amass${endColour}"
echo -e "======================"
amass enum -d $domain | grep $domain | awk '{print $1}' | sort -u >> $domain/subdomains.txt 


echo -e "\n${greenColour}Encontrando dominios vivos${endColour}"
echo -e "\n=========================="
cat $domain/subdomains.txt | grep $domain | sort -u | httprobe -prefer-http | grep https | tr -d '//' | cut -d ':' -f 2 | tee -a $domain/alive.txt

echo -e "\n\n${greenColour}Tomando screenshots de los dominios vivos${endColour}"
echo -e "\n===================="
gowitness file -f $domain/alive.txt -P $screenshot/ --no-http
tput cnorm




