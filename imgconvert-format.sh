#!/bin/bash

#This script creates a new directory, converts the formats of all specified images within a the workdir and places
#the converted images inside the newly created directory

cd ~/Desktop/scripts #Change to the desired path

convert_format(){

echo "Insert the name of the directory where the image files are supposed to be located after conversion: "

read dir_name


if [ ! -d $dir_name ]; then
	mkdir $dir_name
fi

echo "Insert the image format of the files to be converted: Ex:'png'"

read initial_format

echo "Insert the image format to which the files will be converted to: Ex:'jpg'"

read final_format

for img in *.$initial_format
do
	new_file=$(ls $img | awk -F. '{print $1}')
	convert $new_file.$initial_format $dir_name/$new_file.$final_format
done

# The next line excludes all files in the initial format. Uncomment if you wish to do so, otherwise keep it commented.
# rm *.$initial_format

}

convert_format

if [ $? -eq 0 ]; then
	echo "The task was succesfully executed"
else
	echo "There was a problem with the execution"
fi

