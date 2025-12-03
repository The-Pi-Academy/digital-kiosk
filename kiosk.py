# Modified Python Script for Dynamic Kiosk

import tkinter as tk
from datetime import datetime

def update_time():
    # 1. Recalculate the current time every time this function runs
    current_time = datetime.now().strftime("%I:%M:%S %p")
    
    # 2. Update the existing label text
    new_message = f"WELCOME TO THE PI ACADEMY KIOSK!\n\n{current_time}"
    message.config(text=new_message)
    
    # 3. Schedule this function to run again in 1000 milliseconds (1 second)
    window.after(1000, update_time)

window = tk.Tk()
window.title("The Pi Academy Kiosk")
window.attributes('-fullscreen', True) 

# Initial label creation (use a placeholder text)
message = tk.Label(
    text="Initializing Time...",
    font=("Helvetica", 32),
    fg="white", 
    bg="blue"
)
message.pack(expand=True, fill='both')

# Start the first update cycle
update_time()

# Run the window loop
window.mainloop()
