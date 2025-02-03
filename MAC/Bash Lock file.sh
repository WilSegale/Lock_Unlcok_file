#!/bin/bash

# Define constants for URL, OS type, and file names
SITE_URL="https://google.com"  # URL that can be used for checking or references
MAC="darwin"                   # Specify macOS as the target operating system type
password_file=".password.txt"  # File to store the password for user authentication
hint_file=".hint.txt"          # File to store a password hint for the user

# Read the hint from the file (if available)
if [ -f "${hint_file}" ]; then
    hint=$(cat "${hint_file}")  # Read the hint from the file
else
    hint="No hint set."  # If no hint is available, provide a default message
fi

# Function to handle password setup and retrieval
getPassword() {
    # Check if the password file exists, if so, read the saved password from it
    if [ -f "${password_file}" ]; then
        pass=$(cat "${password_file}")  # Read the password from the file
    else
        # If the password file doesn't exist, prompt the user to create a new password
        read -sp "Set a new password: " pass  # Prompt for new password input without showing characters
        echo
        read -sp "Retype your password: " RetypePassword  # Prompt for password re-entry

        # Verify that the passwords match
        if [ "${pass}" != "${RetypePassword}" ]; then
            echo
            echo "ERROR: Passwords don't match. Try again."  # Display error if passwords don't match
            getPassword  # Recursively call the function to retry password setup
        else
            echo "${pass}" > "${password_file}"  # Save the password to the file
        fi
    fi

    # Check if the password hint file exists, if so, read the hint from it
    if [ -f "${hint_file}" ]; then
        hint=$(cat "${hint_file}")  # Read the hint from the file
    else
        # If the hint file doesn't exist, prompt the user to set a password hint
        echo
        read -p "Set a hint for the password: " hint  # Prompt for a password hint
        echo "${hint}" >> "${hint_file}"  # Save the hint to the hint file
    fi
}

# Function to prompt for the password before locking/unlocking a folder
prompt_for_password() {
    # Display the password hint first
    echo "|_ $hint _|"  # Show the password hint

    # Prompt the user to enter their password
    read -sp "Enter password: " entered_password  # Password input is hidden
    echo  # To move to a new line after password input

    # Check if the entered password matches the stored password
    if [ "$entered_password" != "$pass" ]; then
        echo "ERROR: Incorrect password."  # If the entered password doesn't match, show error
        exit 1  # Exit the script due to incorrect password
    fi
}

# Function to lock the folder (set folder permissions to zero, making it inaccessible)
lock_folder() {
    prompt_for_password  # Ensure the user provides the correct password before proceeding
    # Prompt the user to input the folder path they wish to lock
    read -p "Enter the folder path to lock: " folder_path
    if [ -z "$folder_path" ]; then
        echo "ERROR: Folder path is required!"  # Display error if no folder path is provided
        return
    fi

    # Check if the provided folder path is a valid directory
    if [ -d "$folder_path" ]; then
        chmod 000 "$folder_path"  # Lock the folder by removing all read, write, and execute permissions
        echo "Folder $folder_path is now locked."  # Confirmation message
        mv "$folder_path" ".$folder_path"    
    else 
        echo "ERROR: $folder_path is not a valid directory!"  # Display error if the folder path is invalid
    fi
}

# Function to unlock the folder (restore full access to the folder)
unlock_folder() {
    prompt_for_password  # Ensure the user provides the correct password before proceeding
    # Prompt the user to input the folder path they wish to unlock
    read -p "Enter the folder path to unlock: " folder_path
    if [ -z "$folder_path" ]; then
        echo "ERROR: Folder path is required!"  # Display error if no folder path is provided
        return
    fi

    # Check if the provided folder path is a valid directory
    if [ -d "$folder_path" ]; then
        chmod u+rwx "$folder_path"  # Restore read, write, and execute permissions to the folder
        echo "Folder $folder_path is now unlocked."  # Confirmation message
    else
        echo "ERROR: $folder_path is not a valid directory!"  # Display error if the folder path is invalid
    fi
}

# Initialize password setup if needed (calls the getPassword function to check for password setup)
getPassword

# Menu for user selection
echo "Choose an option:"
echo "1. Lock a folder"
echo "2. Unlock a folder"
echo "3. Exit"

# Read the user's choice for the action they want to perform
read -p "Enter your choice (1/2/3): " choice

# Case statement to perform the action based on user's choice
case $choice in
    1) lock_folder ;;   # Call lock_folder function if option 1 is selected
    2) unlock_folder ;; # Call unlock_folder function if option 2 is selected
    3) exit 0 ;;        # Exit the script if option 3 is selected
    *) echo "Invalid choice!" ;;  # Display error if an invalid choice is entered
esac