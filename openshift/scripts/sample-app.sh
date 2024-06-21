#!/bin/bash

# This script is used to create or delete the wordpress app in the cluster
# It uses the correct order of resource yamls to create or delete the app
# Make sure you have logged in to the cluster before running this script,
# and you are in the correct project with sufficient permissions.

# List of resource yamls

# Function to create the list of resource yamls
create_app() {
    search_dir=../sample
    for entry in "$search_dir"/*
    do
      echo "$entry"
      oc apply -f $entry
    done
}

# Function to create the list of resource yamls
delete_app() {
    search_dir=..
    for entry in "$search_dir"/*
    do
      echo "$entry"
      oc delete -f $entry
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
