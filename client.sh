#!/usr/bin/env bash


router="127.1"

send_TCP(){

for id in `seq 10`
do 
    local msg="packet from client"
    local time="`date +%s%3N`" 
    local packet='{id:"161220028", no:"'$id'", msg:"'$msg'", timestamp:"'$time'"}'

    socat - tcp4-connect:$router:5001 2>/dev/null  < <(echo $packet)
    if test ! $? -eq 0
    then
        echo "{TCP}-->Can't connect to A2. Connection Refused" >> client.txt
    else
        echo "CLIENT-->{TCP}: {$msg}{$id}{$time}"   >> client.txt
    fi
    sleep 0.3

done


}
send_UDP(){

for id in `seq 10`
do 
    local msg="packet from client"
    local time="`date +%s%3N`"
    local packet='{id:"161220028", no:"'$id'", msg:"'$msg'", timestamp:"'$time'"}'

    socat - udp4:$router:5001 2>/dev/null  < <(echo $packet)
    if test ! $? -eq 0
    then
        echo "{UDP}-->Can't connect to A2. Connection Refused" >> client.txt
    else
        echo "CLIENT-->{UDP}: {$msg}{$id}{$time}" >> client.txt
    fi
    sleep 0.3


done


}

send_TCP &
send_UDP &
echo -e "\e[32m Sending packets...\e[0m"
