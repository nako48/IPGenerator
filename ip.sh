#!/bin/bash
color(){
merah='\e[91m'
cyan='\e[96m'
kuning='\e[93m'
oren='\033[0;33m' 
margenta='\e[95m'
biru='\e[94m'
ijo="\e[92m"
putih="\e[97m"
normal='\033[0m'
bold='\e[1m'
labelmerah='\e[41m'
labelijo='\e[42m'
labelkuning='\e[43m'    
}
cat << "EOF"
                      .".
                     /  |
                    /  /
                   / ,"
       .-------.--- /
      "._ __.-/ o. o\
         "   (    Y  )
              )     /
             /     (
            /       Y
        .-"         |
       /  _     \    \
      /    `. ". ) /' )
     Y       )( / /(,/
    ,|      /     )
   ( |     /     /
    " \_  (__   (__        [NakoCoders - IP Grabbing + Checker LIVE]
        "-._,)--._,)
EOF
echo ""
read -p "Mau Berapa IP ? : " limit
for(( i=1; $i <=$limit; i++ )); do 
	echo $((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))>>hasil.txt
done
sort hasil.txt | uniq >> ips.txt
rm -rf hasil.txt
port80(){
	color
	# port=('80')
	# randport=${port[$RANDOM % ${#port[@]}]}
	checkip=$(curl -skL --connect-timeout 15 --max-time 15 "https://portchecker.co/" \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
	-H 'Accept-Language: id,en-US;q=0.7,en;q=0.3' \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	-H 'Origin: https://portchecker.co' \
	-H 'Connection: keep-alive' \
	-H 'Referer: https://portchecker.co/' \
	-H 'Upgrade-Insecure-Requests: 1' \
	-H 'TE: Trailers' \
	--data "target_ip=$1&port=80&selectPort=80")
	isopen=$(echo $checkip | grep -Po '(?<=<span class="green">)[^</]*')
	if [[ $checkip =~ "green" ]]; then
		printf "${labelijo}-- LIVE --${normal} ${bold} ${1}:80 => $isopen\n"
		echo "$1">> iplive.txt
	else
		printf "${labelmerah}-- DEAD --${normal} ${bold} ${1}:80\n"
	fi
}
port443(){
	checkip=$(curl -skL --connect-timeout 15 --max-time 15 "https://portchecker.co/" \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
	-H 'Accept-Language: id,en-US;q=0.7,en;q=0.3' \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	-H 'Origin: https://portchecker.co' \
	-H 'Connection: keep-alive' \
	-H 'Referer: https://portchecker.co/' \
	-H 'Upgrade-Insecure-Requests: 1' \
	-H 'TE: Trailers' \
	--data "target_ip=$1&port=443&selectPort=443")
	isopen=$(echo $checkip | grep -Po '(?<=<span class="green">)[^</]*')
	if [[ $checkip =~ "green" ]]; then
		printf "${labelijo}-- LIVE --${normal} ${bold} ${1}:443 => $isopen\n"
		echo "$1">> iplive.txt
	else
		printf "${labelmerah}-- DEAD --${normal} ${bold} ${1}:443\n"
	fi
}
http(){
	port80 $1 && port443 $1
	ngecurl=$(curl -s -k -I --compressed --connect-timeout 30 --max-time 30 "$1" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: id,en-US;q=0.7,en;q=0.3' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'TE: Trailers')
	if [[ $ngecurl =~ "200 OK" ]]; then
		printf "${labelijo}-- LIVE --${normal} ${bold} ${1}\n"
		echo "$1">> iplive.txt
	else
		printf "${labelmerah}-- DEAD --${normal} ${bold} ${1}\n"
	fi
}
IFS=$'\r\n' GLOBIGNORE='*' command eval 'bacot=($(cat ips.txt))'
waktumulai=$(date +%s)
for (( i = 0; i <"${#bacot[@]}"; i++ )); do
	WOW="${bacot[$i]}"
	IFS='' read -r -a array <<< "$WOW"
	ipx=${array[0]}
	((cthread=cthread%250)); ((cthread++==0)) && wait
	http ${ipx} &
done
wait
