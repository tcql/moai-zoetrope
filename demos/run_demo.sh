#!/bin/bash
OPTIONS="`find . -maxdepth 1 -type d -printf '%f ' | sed -e 's/\. //g'` Quit"

select opt in $OPTIONS; do 
	if [ "$opt" = "Quit" ]; then 
		echo done 
		exit
	elif [ -d "$opt" ]; then
		cp -R ../zoetrope "$opt"
		cd "$opt"
		moai main.lua
		exit
	else
		echo "Invalid option"
	fi
done