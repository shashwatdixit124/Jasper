#!/bin/bash

echo "Setting Project Directories";

if cp -r WebContent/. ./ ; then
	if mkdir WEB-INF/classes ; then
		if cp -R src/jasper WEB-INF/classes/jasper ; then
			echo "Directory Set";
		else
			echo -e "\nError : cannot copy package jasper to WEB-INF/classes/jasper";
			exit 1;
		fi
	else
		echo -e "\nError : cannot create directory WEB-INF/classes"; 
		exit 1;
	fi
else 
	echo -e "\nError : cannot copy content from `pwd`/WebContent to `pwd`";
	exit 1;
fi

export CLASSPATH=`pwd`/WEB-INF/classes:$CLASSPATH
cd WEB-INF/classes

echo "Building Packages";

if javac jasper/helper/* && javac jasper/db/* && javac jasper/login/* && javac jasper/data/* ; then
	echo "Packages Built";
else
	echo -e "\nError : building Packages";
	exit 1;
fi

cd ../../

echo -e "\nSetup Completed"
