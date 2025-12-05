# Modified Python Script for Dynamic Kiosk

import tkinter as tk
from datetime import datetime
import colorsys

def get_rainbow_color():
    """
    Generate a rainbow color based on time of day.
    Completes a full rainbow cycle every 24 hours.
    Returns a hex color string.
    """
    # Get current time in seconds since midnight
    now = datetime.now()
    seconds_since_midnight = now.hour * 3600 + now.minute * 60 + now.second

    # Calculate hue (0.0 to 1.0) - full cycle every 24 hours (86400 seconds)
    hue = (seconds_since_midnight / 86400.0) % 1.0

    # Convert HSV to RGB (saturation=0.6 for softer colors, value=0.5 for darker bg)
    rgb = colorsys.hsv_to_rgb(hue, 0.6, 0.5)

    # Convert to hex color
    r, g, b = [int(x * 255) for x in rgb]
    return f"#{r:02x}{g:02x}{b:02x}"

def update_time():
    # 1. Recalculate the current time every time this function runs
    current_time = datetime.now().strftime("%I:%M:%S %p")

    # 2. Get the current rainbow color
    bg_color = get_rainbow_color()

    # 3. Update the label text and background color
    new_message = f"WELCOME TO THE PI ACADEMY KIOSK!\n\n{current_time}"
    message.config(text=new_message, bg=bg_color)

    # 4. Update window background to match
    window.config(bg=bg_color)

    # 5. Schedule this function to run again in 1000 milliseconds (1 second)
    window.after(1000, update_time)

window = tk.Tk()
window.title("The Pi Academy Kiosk")
window.attributes('-fullscreen', True) 

# Initial label creation (use a placeholder text)
message = tk.Label(
    text="Initializing Time...",
    font=("Helvetica", 32),
    fg="white",
    bg=get_rainbow_color()
)
message.pack(expand=True, fill='both')

# Start the first update cycle
update_time()

# Run the window loop
window.mainloop()
