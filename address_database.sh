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
    clear
}

searchOrEditEntry(){
    searchScreen(){
        echo "Database Project"
        echo
        echo -e "\033[0;31mSearch\033[0m/Edit"
        echo 
        echo "1. Name           : "       
        echo "2. Email          : "       
        echo "3. Tel No         : "       
        echo "4. Moblie No      : "       
        echo "5. Address        : "       
        echo "6. Message        : "
        echo
    }
    searchScreen
    echo -n "Enter Search Info: "
    read info
    query=`grep -m 1 "$info" Database/Database.csv`
    if [ -z $query ]; then
        echo "No Matching Found"
        echo
        searchScreen
    fi
    IFS=',' read -r name email tel mob address msg <<< "$query"
    clear
    editScreen(){
        echo "Database Project"
        echo
        echo -e "Search/\033[0;31mEdit\033[0m"
        echo 
        echo "1. Name           : $name "       
        echo "2. Email          : $email"       
        echo "3. Tel No         : $tel"       
        echo "4. Moblie No      : $mob"       
        echo "5. Address        : $address"       
        echo "6. Message        : $msg"
        echo -e "\033[0;31mx\033[0m. Exit"
        echo
        echo -n "Enter the Field Number you Want to edit: "
        read -n 1 idx 
        if [ $idx -eq 1 ]; then
            echo
            enterName(){
                echo -n "Enter the New Name: "
                read newname
                nameValidation $newname
            }
            enterName
            if [ $? -eq 1 ]; then 
                echo "Please Enter a Valid Name"
                echo
                enterName
            fi
            awk -F, -v OFS=, -v target="$name" -v anewname=$newname  'NR == 1  { print; next } { if ($1 == target){ $1 = anewname } print }' "Database/Database.csv" > Database/temp.csv && mv Database/temp.csv Database/Database.csv
            name=$newname
            clear
            editScreen
        elif [ $idx -eq 2 ]; then
            echo
            enterEmail(){
                echo -n "Enter the New Email: "
                read newemail
                emailValidation $newemail
            }
            enterEmail
            if [ $? -eq 1 ]; then 
                echo "Please Enter a Valid Email"
                echo
                enterEmail
            fi
        awk -F, -v OFS=, -v target="$name" -v anewemail=$newemail 'NR == 1  { print; next } { if ($1 == target){ $2 = anewemail } print }' "Database/Database.csv" > Database/temp.csv && mv Database/temp.csv Database/Database.csv
        email=$newemail
        clear
        editScreen
        elif [ $idx -eq 3 ]; then
            echo
            enterTel(){
                echo -n "Enter the New Tel No: "
                read newtel
                numberValidation $newtel
            }
            enterTel
            if [ $? -eq 1 ]; then 
                echo "Please Enter a Valid Tel No"
                echo
                enterTel
            fi
        awk -F, -v OFS=, -v target="$name" -v anewtel=$newtel  'NR == 1  { print; next } { if ($1 == target){ $3 = anewtel } print }' "Database/Database.csv" > Database/temp.csv && mv Database/temp.csv Database/Database.csv
        tel=$newtel
        clear
        editScreen
        elif [ $idx -eq 4 ]; then
            echo
            enterMob(){
                echo -n "Enter the New Mobile No: "
                read newmob
                mobileValidation $newmob
            }
            enterMob
            if [ $? -eq 1 ]; then 
                echo "Please Enter a Valid Mobile No"
                echo
                enterMob
            fi
            awk -F, -v OFS=, -v target="$name" -v anewmob=$newmob  'NR == 1  { print; next } { if ($1 == target){ $4 = anewmob } print }' "Database/Database.csv" > Database/temp.csv && mv Database/temp.csv Database/Database.csv
            mob=$newmob
            clear
            editScreen
        elif [ $idx -eq 5 ]; then
            echo
            enterAdress(){
                echo -n "Enter the New Adress: "
                read newadress
            }
            enterAdress
            awk -F, -v OFS=, -v target="$name" -v anewaddress=$newadress  'NR == 1  { print; next } { if ($1 == target){ $5 = anewaddress } print }' "Database/Database.csv" > Database/temp.csv && mv Database/temp.csv Database/Database.csv
            address=$newadress
            clear
            editScreen 
        elif [ $idx -eq 6 ]; then
            echo
            enterMessage(){
                echo -n "Enter the New Message: "
                read newmsg
            }
            enterMessage
            awk -F, -v OFS=, -v target="$name" -v anewmsg=$newmsg  'NR == 1  { print; next } { if ($1 == target){ $6 = anewmsg } print }' "Database/Database.csv" > Database/temp.csv && mv Database/temp.csv Database/Database.csv
            msg=$newmsg
            clear
            editScreen
        elif [[ "$idx" = "x" || "$idx" = "X" ]]; then
            clear 
            exit
            echo "$currentdate || Scrpit Exited"
        else
            clear
            echo "Please enter A Valid Field Number"
            echo
            editScreen
        fi
    }
    editScreen
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
