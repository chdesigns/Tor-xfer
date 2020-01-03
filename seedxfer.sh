#!/bin/bash
#Gathers Files list from Seedbox
ssh [hostname] ls  /home/seeduser/downloads/ > bigseedlist.out

function downloadscp {
        i=0
        
        input="bigseedlist.new"
        #Loop reads through modified file list to download selected entry
        while IFS= read -r line
        do
         if [ "$1" = "$i" ]; then
               echo "$line"
               scp -r root@[hostname]:/home/seeduser/downloads/"$line" /torrent/Download/
         fi
         let i++;

        done < "$input"
}

#Function takes file list and adds numerical selections to the name
function bigloop {
if [ "$1" = "99" ]; then
        i=0
        cat bigseedlist.out | while read line
        do
           echo "$i: $line";
           let i++;
        done
fi

}

#Call Function bigloop with dummy number
bigloop 99

#Adds backslash to file name with spaces so that SCP will work
sed   's/\ /\\\ /g' bigseedlist.out >> bigseedlist.new

echo ""
echo "Please enter in which number to download"
read link

#Calls function downloadscp with number selected by user
downloadscp $link
rm -rf bigseedlist.out bigseedlist.new
