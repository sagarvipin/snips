#!/bin/bash
echo -e "\n**** IMPORTANT ****\n"
echo You need to run this script on the same DIR where the XML file resides. This script split the input xml files consists of maximum provided records per file
echo -e "\n"
read -p "Maximum records expected in a file : " records
read -p "Enter the XML file name: " filename
echo -e "\nYou have entered XML file name as : $filename"
ls $filename 2> /dev/null

if [ $? -eq 0 ]
then
        echo -e "File exist - Spliting starts now \n"
else
        echo -e "\nFile does not exist in the present woring directory; please try again" >&2
fi
# label "Start" is hard-coded entry for a this specific XML or we can take a user infut
count=`grep -o Start $filename | wc -l`
recount=$((count / records))
awk 'BEGIN{a=0;i=0} /<Start/ {a=1} /<Break/ {print > "hook_" i ".xml";i++;a=0} {if (a==1) print > "hook_" i ".xml"}' $filename

finfile=finle
date=`date +%m%d%Y_%H%M%S`
x=1
y=1
park=''
for bang in `ls -v hook_*`;do
  if [ "$park" = '' ] && [ $x -le $records ]
  then
    park=$bang
    cat $park>> "$finfile"_"$y"_"$date".xml
    x=$((x + 1))
    rm $park
    park=''
  else
   y=$((y + 1))
   x=1
   cat $bang >> "$finfile"_"$y"_"$date".xml
   rm $bang
  fi
done
# The below is to add the header and footer to the splitted files

for lore in `ls -v "$finfile"*`; do
        sed -i -e '1i<?xml version="1.0" encoding="ISO-8859-1"?>\n<Root xmlns="http://bac.com/xmlschema/atm/Journal">' "$lore" &&
        echo '</Root>' >> "$lore"
done
