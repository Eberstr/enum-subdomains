# enum-subdomains

**Bash script to automate passive subdomain enumeration.**  
This script combines the results from three different tools (Subfinder, Assetfinder, and Amass) to create a list of subdomains using OSINT sources.
The resultsa are then passed through `httprobe` to identify the ones that are still alive.

## Usage:
```
git clone https://github.com/Eberstr/enum-subdomains.git

cd enum-subdomains

chmod +x enum-subdomains.sh

./enum-subdomains.sh example.com
```
