#!/bin/bash
#
# Revoke access to multiple Google Drive files
# This tool is using `gdrive` https://github.com/prasmussen/gdrive
# Jeromin @Weedo.Agency <me@jeromin.fr>

cmd_name=$(basename "${BASH_SOURCE[0]}")

usage() {
    printf "\e[1;1mUsage:\e[m\n"
    echo "	$cmd_name list fileID					List file permissions with permission ID"
    echo "	$cmd_name [-s number] show filename emailaddress 	Save files shared with"
    echo "	$cmd_name [-p] revoke filename permisionID		Revoke permission with"
    printf "\e[1;1mGlobal:\e[m\n"
    echo "	-a 	Google service account key needed for gdrive (located in ~/.gdrive)"
    printf "\e[1;1mOptions:\e[m\n"
    echo "	-s 	Split result in n lines"
    echo "	-p 	Use splitted files to run in parallel"
    exit
}

while getopts "a:e:i:s:p" arg; do
  case $arg in
  	a) service_account=${OPTARG};;
    s) split_number=${OPTARG};;
    p) splitted=true;;
  esac
done

shift $(($OPTIND - 1))

if [ -z $service_account ]; then echo "Service account file key is needed [-a key.json]"; echo; usage; exit 1; fi 

revoke() {
	for line in $(awk -F'  ' '{print $1}' "$1"); do
		count=$((count+1)); printf "%s: %s " $count $(awk -F'  ' '$1=="'$line'"{print $2}' "$1")
		gdrive --service-account $service_account share revoke $line $permision_id
	done
	echo "Revocation done !"
}

revoke_cmd() {
	log_file="revoke_shared_access_${1}.log";
	revoke "$@" > "$log_file" 2>&1 &
	printf "Log file: \e[1;1m%s$log_file\e[m and PID: \e[1;1m${!}\e[m\n"
}

case $1 in
	list) gdrive --service-account $service_account share list $2;;
	show)
		sharedwith="$3"
		if [ -z $sharedwith ]; then echo "Email to search for is is needed !"; echo; usage; exit 1; fi 
		if [ ! -z "$split_number" ] && ! [[ "$split_number" =~ ^[0-9]+$ ]]; then echo "-s option value must be a number"; fi

		gdrive --service-account $service_account list -q "'$sharedwith' in writers" -m 99999999999 > "${2}.tmp" && awk 'NR>1' "${2}.tmp" > "$2" \
			&& rm "${2}.tmp" && objects_number=$(cat "$2" | wc -l) && printf "   \e[1;1m%s\e[m objects listed " $objects_number
		if [ ! -z "$split_number" ]; then
			split -l $split_number "$2" "${2%.*}_" && printf "splitted in \e[1;1m%s\e[m files \n" $(ls "${2%.*}_"* | wc -l); else printf "\n"; fi
	;;
	revoke)
		permision_id=$3
		if [ -z $permision_id ]; then echo "Permission ID is needed !"; echo; usage; exit 1; fi 

		if [ -z "$splitted" ]; then
			revoke_cmd $2 $permision_id
		else
			for sp in $(ls "${2%.*}_"*); do
				revoke_cmd $sp $permision_id
			done
			echo "Kill all jobs with: kill {PID...PIDN}"
		fi
	;;
	help | *) usage;;
esac



