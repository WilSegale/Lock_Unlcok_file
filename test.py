import os
import stat
import tkinter as tk
from tkinter import messagebox

# Function to lock the folder
def lock_folder():
    folder_path = folder_entry.get()
    if not folder_path:
        messagebox.showerror("Error", "Please enter a valid folder path.")
        return

    try:
        os.chmod(folder_path, 0)  # Lock the folder by removing all read, write, and execute permissions
        messagebox.showinfo("Success", f"Folder {folder_path} is now locked.")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to lock folder: {e}")

# Function to unlock the folder
def unlock_folder():
    folder_path = folder_entry.get()
    if not folder_path:
        messagebox.showerror("Error", "Please enter a valid folder path.")
        return

    try:
        os.chmod(folder_path, stat.S_IRWXU)  # Grants read, write, and execute permissions to the owner
        messagebox.showinfo("Success", f"Folder {folder_path} is now unlocked.")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to unlock folder: {e}")

# Initialize the GUI window
root = tk.Tk()
root.title("Folder Lock/Unlock")

# Label for the folder path
folder_label = tk.Label(root, text="Enter the folder path:")
folder_label.pack(pady=10)

# Text entry for folder path
folder_entry = tk.Entry(root, width=40)
folder_entry.pack(pady=10)

# Buttons for Lock and Unlock actions
lock_button = tk.Button(root, text="Lock Folder", command=lock_folder)
lock_button.pack(pady=5)

unlock_button = tk.Button(root, text="Unlock Folder", command=unlock_folder)
unlock_button.pack(pady=5)

# Start the GUI loop
root.mainloop()
