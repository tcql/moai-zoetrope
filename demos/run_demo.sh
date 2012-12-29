#!/bin/bash
OPTIONS="`find \`ls -l | awk ' /^d/ {print $NF }'\` -maxdepth 0 -type d -printf '%f '` Quit"



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
