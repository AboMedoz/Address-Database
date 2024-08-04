#!/bin/bash

currentdate=$(date +"%Y-%m-%d %H:%M:%S")

makeLogs(){
    if [ ! -f database.log ]; then
        touch database.log
        echo "$currentdate || Script Invoked." >> database.log
    fi
}

makeDatabase(){
    if [ ! -f "Database/Database.csv" ]; then
        touch "Database/Database.csv"
        echo "Name,Email,Tel No,Mobile No,Address,Message" >> "Database/Database.csv"
        echo "$currentdate || Database Created." >> database.log
    fi
}

addEntry(){
    # name=''
    # email=''
    # tel=''
    # mob=''
    # address=''
    # msg=''
    # while (true);
    #     do
    #         echo "Database Project"
    #         echo
    #         echo "Add new Entry Screen"
    #         echo 
    #         echo "1. Name           : $name"       
    #         echo "2. Email          : $email"       
    #         echo "3. Tel No         : $tel"       
    #         echo "4. Moblie No      : $mob"       
    #         echo "5. Address        : $address"       
    #         echo "6. Message        : $msg"
    #         echo -e "\033[0;31mx\033[0m. Exit"
    #         echo
    #         echo -n "Please choose a Field to be added: "
    #         read idx
    #         clear
    #     done
    echo "TODO"
}

searchOrEditEntry(){
    #TODO
    echo "TODO"
}

main(){
    makeLogs
    makeDatabase
    echo "Database Project"
    echo "Please choose an Option"
    echo
    echo "1. Add Entry"  
    echo "2. Search / Edit Entry"  
    echo -e "\033[0;31mx\033[0m. Exit"
    echo 
    echo "Note: Script Timeout is Set"
    echo 
    echo -n  "Choose an Option: "
    read -n 1 -t 10 option
    if [ -z $option ]; then
        echo "$currentdate || Script Exited." >> database.log
        exit
    fi
    if [ $option -eq 1 ]; then
        clear
        addEntry
    elif [ $option -eq 2 ]; then
        clear
        searchOrEditEntry
    elif [[ "$option" = "x" || "$option" = "X" ]]; then
        clear
        exit
    else
        clear
        echo "Please Enter a Valid Option" 
        echo
        main
    fi
}

main
