import os
import stat
import subprocess

# Example command to list files in a directory
os.system("ls -a")

# Path to the folder you want to lock
def lock():
    try:
        print('Input the folder or file to lock')
        folder_path = input("Folder $ ")
        choice = input("Choice # ")

        if choice == "lock":
            # Lock the folder by removing all read, write, and execute permissions
            os.chmod(folder_path, 0)

            print(f"Folder {folder_path} is now locked.")


        elif choice == "unlock":        # To unlock, you can restore the permissions like this:
            os.chmod(folder_path, stat.S_IRWXU)  # Grants read, write, and execute permissions to the owner
            print(f"Folder {folder_path} is now unlocked.")
        else:
            print(f"ERROR I DONT KNOW WHAT YOU MEAN BY {choice}")
            return lock()
    except KeyboardInterrupt as key:
        print("\nExiting the Lock_Unlock file")
lock()