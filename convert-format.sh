#!/bin/bash

cd ~/Desktop/scripts #Change to the desired path

convert_format(){

echo "Insert the name of the directory where files are supposed to be located after conversion: "

read dir_name


if [ ! -d $dir_name ]; then
	mkdir $dir_name
fi

echo "Insert the format of files to be converted: Ex:'pdf'"

read initial_format

echo "Insert the format to which the files will be converted to: Ex:'txt'"

read final_format

for file in *.$initial_format
do
	new_file=$(ls $file | awk -F. '{print $1}')
	convert $new_file.$initial_format $dir_name/$new_file.$final_format
done

# The next line excludes all files in the initial format. Uncomment if you wish to do so otherwise keep it commented.
# rm *.$initial_format

}

convert_format

if [ $? -eq 0 ]; then
	echo "The task was succesfully executed"
else
	echo "There was a problem with the execution"
fi

