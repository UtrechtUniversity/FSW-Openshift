#!/bin/bash

# This script is used to create or delete the wordpress app in the cluster
# It uses the correct order of resource yamls to create or delete the app
# Make sure you have logged in to the cluster before running this script,
# and you are in the correct project with sufficient permissions.

# List of resource yamls

# Function to create the list of resource yamls
create_app() {
    search_dir=../config
    for entry in "$search_dir"/*
    do
        filename=$(basename -- "$entry")
        if [ -f ../temp/"$filename" ]; then
            echo "Use previously made file with credentials"
            oc apply -f ../temp/"$filename"
            continue
        fi

        echo "Check for file with credential"
        match=$(grep -o \<.*\> "$entry" | wc -l)
        if [ "$match" -ne "0" ]; then
            echo "Found credentials in file"
            # TODO: Create loop and ceck ninimal length of password
            word1=$(shuf -n1 /usr/share/dict/american-english | sed "s/'//g")
            word2=$(shuf -n1 /usr/share/dict/american-english | sed "s/'//g")
            word3=$(shuf -n1 /usr/share/dict/american-english | sed "s/'//g")
            word="${word1}-${word2}-${word3}"
            echo "used password: $word for $filename"
            hash="$(echo -n $word | base64)"
            echo $hash
            sed "s/<.*>/"$hash"/g" "$entry" > ../temp/"$filename"
            oc apply -f ../temp/"$filename"
            continue
        fi
        echo "$entry"
        oc apply -f "$entry"
    done
}

# Function to create the list of resource yamls
delete_app() {
    search_dir=../config
    for entry in "$search_dir"/*
    do
      echo "$entry"
      oc delete -f "$entry"
    done
}

# Function to display the menu
show_menu() {
    echo "Please choose an option:"
    echo "1) create sample app"
    echo "2) delete sample app"
    echo "3) exit"
}

# Main script loop
while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            create_app
            break
            ;;
        2)
            delete_app
            break
            ;;
        3)
            echo "Exiting the script."
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done
