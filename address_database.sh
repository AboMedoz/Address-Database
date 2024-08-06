#!/bin/bash

currentdate=$(date +"%Y-%m-%d %H:%M:%S")

makeLogs(){
    if [ ! -f database.log ]; then
        touch database.log
        echo "$currentdate || Script Invoked." >> database.log
    fi
}

makeDatabase(){
    if [ ! -d Database ]; then
        mkdir Database
    fi
    if [ ! -f "Database/Database.csv" ]; then
        touch "Database/Database.csv"
        echo "Name,Email,Tel No,Mobile No,Address,Message" >> "Database/Database.csv"
        echo "$currentdate || Database Created." >> database.log
    fi
}

nameValidation(){
    local input="$1"
    if [[ "$input" =~ ^[a-zA-z\ ]*$ || -z $input ]]; then
        return 0
    else 
        return 1
    fi
}

emailValidation(){
    local input="$1"
    if [[ "$input" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ || -z $input ]]; then
        return 0
    else 
        return 1
    fi
}

numberValidation(){
    local num="$1"
    if [[ "$num" =~ ^[0-9]+$ || -z $num ]]; then
        return 0
    else
        return 1
    fi
}

mobileValidation(){
    local num="$1"
    if [[ "$num" =~ ^[0-9]+$ && ${#num} -ge 10  || -z $num ]]; then
        return 0
    else
        return 1
    fi
}

addEntry(){
    name=''
    email=''
    tel=''
    mob=''
    address=''
    msg=''
    tarr=("Name" "Email" "Tel No" "Mobile No" "Adress" "Message")
    varr=()
    idx=0
    loop(){
    while [ $idx -le 5 ]; do
            echo "Database Project"
            echo
            echo "Add new Entry Screen"
            echo 
            echo "1. Name           : $name "       
            echo "2. Email          : $email "       
            echo "3. Tel No         : $tel "       
            echo "4. Moblie No      : $mob "       
            echo "5. Address        : $address "       
            echo "6. Message        : $msg "
            echo
            field=${tarr[$idx]} 
            echo -n "Please choose a $field to be added: " 
            read fill
            if [ $idx -eq 0 ]; then
                nameValidation $fill
                if [ $? -eq 1 ]; then
                    clear
                    echo "Please enter a Valid Name"
                    echo
                    loop
                fi
            fi
            if [ $idx -eq 1 ]; then
                emailValidation $fill 
                if [ $? -eq 1 ];then
                    clear
                    echo "Please Enter a Valid Email"
                    echo 
                    loop
                fi
            fi
            if [ $idx -eq 2 ]; then
                numberValidation $fill
                if [ $? -eq 1 ]; then
                    clear
                    echo "Enter only Numbers"
                    echo 
                    loop
                fi
            fi
            if [ $idx -eq 3 ]; then
                mobileValidation $fill
                if [ $? -eq 1 ]; then
                    clear
                    echo "Enter a Valid Mobile Numbers"
                    echo 
                    loop
                fi
            fi
            varr[$idx]+=$fill
            name=${varr[0]}
            email=${varr[1]}
            tel=${varr[2]}
            mob=${varr[3]}
            address=${varr[4]}
            msg=${varr[5]}
            (( idx++ ))
        done
    }
    loop
    echo "$name,$email,$tel,$mob,$address,$msg" >> Database/Database.csv
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
