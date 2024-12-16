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
    

ctrl_c(){
	echo -e "\n\n${redColour}[i] Saliendo...${endColour}\n"
	tput cnorm && exit 1
}

#ctrl c
trap ctrl_c INT

subfinder_enum(){
	
	echo -e "\nEnumerando con subfinder"
	echo -e "=========================="
	subfinder -d $domain -o subfinderfounds.txt

}

assetfinder_enum(){

	echo -e "\nEnumerando con assetfinder"
	echo -e "============================"
	assetfinder $domain > assetfinderfounds.txt

}

amass_enum(){

	echo -e "\nEnumerando con amass"
	echo -e "======================"
	amass enum -d $domain | grep $domain | awk '{print $1}' | sort -u > amassfounds.txt

}

parse_results(){

	domain = "$1"
	subfinder_enum $domain
	assetfinder_enum $domain
	amass_enum $domain

	cat assetfinderfounds.txt amassfounds.txt subfinderfounds.txt | grep $domain | awk '{print $1}' | sort -u >> subdomains_final.txt



}
