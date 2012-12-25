#!/bin/bash
OPTIONS="`find . -type d -printf '%f ' | sed -e 's/\. //g'` Quit"

select opt in $OPTIONS; do 
	if [ "$opt" = "Quit" ]; then 
		echo done 
		exit
	elif [ -d "$opt" ]; then
		cp -R ../zoetrope "$opt"
		cd "$opt"
		moai main.lua&
		rm -rf "$opt/zoetrope/"
		exit
	else
		echo "Invalid option"
	fi
done