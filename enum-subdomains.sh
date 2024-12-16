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
    

domain="$1"

if [ -z $domain ]; then
	echo -e "\n\n${redColour}[i] Dominio no espeficado${endColour}\n"
	exit 1
fi

ctrl_c(){
	echo -e "\n\n${redColour}[i] Saliendo...${endColour}\n"
	tput cnorm && exit 1
}

#ctrl c
trap ctrl_c INT

# tools_verfication(){

# }

subfinder_enum(){
	
	echo -e "\nEnumerando con subfinder"
	echo -e "=========================="
	subfinder -silent -d $domain -o subfinderfounds.txt

}

assetfinder_enum(){

	echo -e "\nEnumerando con assetfinder"
	echo -e "============================"
	echo -e 
	assetfinder $domain > assetfinderfounds.txt

}

amass_enum(){

	echo -e "\nEnumerando con amass"
	echo -e "======================"
	amass enum -d $domain | grep $domain | awk '{print $1}' | sort -u > amassfounds.txt 

}

parse_results(){
	
	tput civis
	subfinder_enum $domain
	assetfinder_enum $domain
	amass_enum $domain

	cat assetfinderfounds.txt amassfounds.txt subfinderfounds.txt | grep $domain | awk '{print $1}' | sort -u >> subdomains_final.txt 
}

alive_domains(){
	echo -e "\nEncontrando dominios vivos"
	echo -e "\n=========================="
	cat subdomains_final.txt | httprobe > subdomains_alive.txt
	rm subdomains_final.txt 

	echo -e "\nVisitando los sitios"
	echo -e "\n===================="
	mkdir sitepics
	cat subdomains_alive.txt | tr -d '//' | cut -d ':' -f 2 | xargs gowitness -P sitepics
	tput cnorm
}

parse_results
alive_domains
rm subfinderfounds.txt assetfinderfounds.txt amassfounds.txt


