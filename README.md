# 🖥️ Pi Academy Digital Kiosk

Welcome! This project helps you create a cool digital kiosk display on your Raspberry Pi that shows a welcome message with a live updating clock.

## What Does This Do?

This Python program creates a full-screen window that displays:
- A welcome message: "WELCOME TO THE PI ACADEMY KIOSK!"
- A live clock that updates every second
- The time is shown in 12-hour format (with AM/PM)
- A **slowly changing rainbow background** that cycles through all colors over 24 hours

## What You Need

- **Raspberry Pi Zero 2W** (or any Raspberry Pi)
- **Raspberry Pi OS** (with desktop) installed
- **Monitor/Display** connected to your Pi
- **Keyboard and mouse** (for initial setup)

## Files in This Project

- `kiosk.py` - The main Python program that creates the kiosk display with rainbow background
- `start_kiosk.sh` - Shell wrapper script with delay and error logging
- `setup_autostart.sh` - Automatic setup script for Raspberry Pi autostart configuration
- `kiosk.desktop` - Desktop entry file for autostart (created by setup script)
- `README.md` - This file!

## Quick Start (Automatic Setup)

If you're using a **Raspberry Pi Zero 2W** with the default Raspberry Pi OS, we made it super easy!

1. **Download all the files** to your Raspberry Pi (into a folder like `/home/pi/digital-kiosk`)

2. **Open the Terminal** (click the black terminal icon at the top of your screen)

3. **Navigate to the folder**:
   ```bash
   cd /home/pi/digital-kiosk
   ```

4. **Run the setup script**:
   ```bash
   bash setup_autostart.sh
   ```

5. **Reboot your Pi** when the script finishes:
   ```bash
   sudo reboot
   ```

6. **Done!** When your Pi restarts, the kiosk will automatically appear in full-screen!

## Understanding the Code

Let's look at what the Python code does:

### Importing Libraries
```python
import tkinter as tk
from datetime import datetime
import colorsys
```
- `tkinter` - Creates windows and graphics (comes with Python!)
- `datetime` - Gets the current time and date
- `colorsys` - Helps convert HSV colors to RGB for the rainbow effect

### The Rainbow Color Function
```python
def get_rainbow_color():
    now = datetime.now()
    seconds_since_midnight = now.hour * 3600 + now.minute * 60 + now.second
    hue = (seconds_since_midnight / 86400.0) % 1.0
    rgb = colorsys.hsv_to_rgb(hue, 0.6, 0.5)
    r, g, b = [int(x * 255) for x in rgb]
    return f"#{r:02x}{g:02x}{b:02x}"
```
This function:
1. Calculates how many seconds have passed since midnight
2. Converts that to a hue value (0.0 to 1.0) for a full rainbow cycle every 24 hours
3. Converts HSV color to RGB
4. Returns a hex color string (like "#4d3d7f")

### The Update Function
```python
def update_time():
    current_time = datetime.now().strftime("%I:%M:%S %p")
    bg_color = get_rainbow_color()
    new_message = f"WELCOME TO THE PI ACADEMY KIOSK!\n\n{current_time}"
    message.config(text=new_message, bg=bg_color)
    window.config(bg=bg_color)
    window.after(1000, update_time)
```
This function:
1. Gets the current time
2. Gets the current rainbow color based on time of day
3. Formats the message to look nice (example: "02:30:45 PM")
4. Updates the message and background color on screen
5. Schedules itself to run again in 1 second (1000 milliseconds)

### Creating the Window
```python
window = tk.Tk()
window.title("The Pi Academy Kiosk")
window.attributes('-fullscreen', True)
```
This creates a window and makes it full-screen!

### Creating the Label
```python
message = tk.Label(
    text="Initializing Time...",
    font=("Helvetica", 32),
    fg="white",
    bg=get_rainbow_color()
)
message.pack(expand=True, fill='both')
```
This creates the text label with:
- White text (`fg="white"`)
- Rainbow background that changes over time (`bg=get_rainbow_color()`)
- Large font (size 32)
- Text centered in the window

## Customization Ideas

Want to make it your own? Try changing these:

### Change to a Static Color (Instead of Rainbow)
If you prefer a solid color background, replace the rainbow background with a static color:
```python
# In the update_time() function, replace:
bg_color = get_rainbow_color()

# With a static color like:
bg_color = "blue"  # Try: "red", "green", "darkgreen", "purple", "black"
```

### Change the Text Color
```python
message = tk.Label(
    text="Initializing Time...",
    font=("Helvetica", 32),
    fg="yellow",      # Try: "red", "green", "black", "purple", "cyan"
    bg=get_rainbow_color()
)
```

### Adjust Rainbow Speed
Change how fast the rainbow cycles by modifying the hue calculation:
```python
# Full cycle every 12 hours (faster):
hue = (seconds_since_midnight / 43200.0) % 1.0

# Full cycle every 1 hour (much faster):
hue = (seconds_since_midnight / 3600.0) % 1.0
```

### Adjust Rainbow Colors
Change the saturation and value in the `get_rainbow_color()` function:
```python
# Brighter, more saturated colors:
rgb = colorsys.hsv_to_rgb(hue, 0.8, 0.7)

# Pastel colors:
rgb = colorsys.hsv_to_rgb(hue, 0.3, 0.9)

# Dark, muted colors (current setting):
rgb = colorsys.hsv_to_rgb(hue, 0.6, 0.5)
```

### Change the Font Size
```python
font=("Helvetica", 50)  # Make it bigger!
font=("Helvetica", 20)  # Make it smaller!
```

### Change the Message
```python
new_message = f"YOUR CUSTOM MESSAGE HERE!\n\n{current_time}"
```

### Add the Date
```python
current_time = datetime.now().strftime("%I:%M:%S %p")
current_date = datetime.now().strftime("%B %d, %Y")
new_message = f"WELCOME TO THE PI ACADEMY KIOSK!\n\n{current_date}\n{current_time}"
```

## Manual Setup (If You Can't Use the Script)

### Step 1: Save the Python File
Make sure `kiosk.py` is saved in `/home/pi/kiosk.py`

### Step 2: Test It
Open Terminal and run:
```bash
python3 /home/pi/kiosk.py
```

Press `ESC` or `Alt+F4` to close the full-screen window.

### Step 3: Set Up Auto-Start

**Note**: For better reliability, we recommend using the automatic setup script (see Quick Start above). If you need to do it manually, follow these steps:

1. Create the autostart directory:
   ```bash
   mkdir -p ~/.config/autostart
   ```

2. Make sure the shell wrapper script is executable:
   ```bash
   chmod +x ~/digital-kiosk/start_kiosk.sh
   ```

3. Create the desktop entry file:
   ```bash
   nano ~/.config/autostart/kiosk.desktop
   ```

4. Add this content:
   ```
   [Desktop Entry]
   Type=Application
   Name=Digital Kiosk
   Exec=/home/pi/digital-kiosk/start_kiosk.sh
   Comment=Starts the Python kiosk application with a 10s delay
   Terminal=false
   NoDisplay=false
   X-GNOME-Autostart-enabled=true
   ```

5. Save and exit:
   - Press `Ctrl+X`
   - Press `Y` (for "yes")
   - Press `Enter`

6. Make the desktop file executable:
   ```bash
   chmod +x ~/.config/autostart/kiosk.desktop
   ```

7. Reboot:
   ```bash
   sudo reboot
   ```

**Why use this method?** The `.desktop` file method works across all modern desktop environments (not just LXDE), and the shell wrapper includes a 10-second delay plus error logging for better reliability.

## 🚪 Exiting the Kiosk and Navigating Away

When you set up the kiosk to run on autostart in full-screen mode, it creates a **locked screen** experience. This is intentional for a kiosk setup, but you need to know how to exit it!

### Method 1: Standard Close (Easiest!)

**Press `Alt+F4`**

This is the standard keyboard shortcut to close the currently active window on Linux. It sends a polite request to the program to quit, and since our Tkinter window responds to this, it will close the kiosk and return you to the Raspberry Pi desktop.

### Method 2: Force Kill (If Alt+F4 doesn't work)

If the standard close doesn't work, you can switch to a **virtual terminal** and force the program to stop:

1. **Press `Ctrl+Alt+F1`** (or `F2`, `F3`, etc. until you see a black text screen)
   - This switches you out of the graphical desktop into a text-only terminal

2. **Log in** with your username and password:
   - Username: `pi`
   - Password: `raspberry` (or whatever you set it to)

3. **Type this command** to stop the Python program:
   ```bash
   sudo killall python3
   ```

4. **Press `Ctrl+Alt+F7`** to switch back to the graphical desktop
   - The kiosk window should now be gone!

### Method 3: Remote Access (Advanced)

If you have another computer on the same network, you can use **SSH** to remotely log into your Pi:

1. Find your Pi's IP address (you can do this before setting up the kiosk using `hostname -I`)
2. From another computer, open a terminal and type:
   ```bash
   ssh pi@YOUR_PI_IP_ADDRESS
   ```
3. Once logged in, you can stop the kiosk with:
   ```bash
   sudo killall python3
   ```

### Quick Reference Table

| Method | Keyboard Shortcut | Description |
|--------|------------------|-------------|
| **Standard Close** | `Alt+F4` | Easiest - Closes the window normally |
| **Force Kill** | `Ctrl+Alt+F1` | Switches to terminal, then use `sudo killall python3` |
| **Back to Desktop** | `Ctrl+Alt+F7` | Returns from terminal to graphical desktop |

## 🛑 How to Disable Autostart Permanently

If you want your Pi to boot back to the normal desktop next time (for example, to edit your code), you need to disable the autostart feature.

### Easy Method: Delete the Desktop File

1. **Exit the kiosk** using one of the methods above to get back to the desktop

2. **Open Terminal** (click the black terminal icon at the top)

3. **Remove the autostart file**:
   ```bash
   rm ~/.config/autostart/kiosk.desktop
   ```

4. **Reboot** to test:
   ```bash
   sudo reboot
   ```

Now your Pi will boot to the normal desktop without the kiosk starting automatically!

### Alternative: Temporarily Disable (Without Deleting)

If you want to temporarily disable autostart without deleting the file:

1. **Rename the desktop file**:
   ```bash
   mv ~/.config/autostart/kiosk.desktop ~/.config/autostart/kiosk.desktop.disabled
   ```

2. Reboot to test

### Re-enabling Autostart

To make the kiosk start automatically again:

**If you deleted the file:** Run the setup script again:
```bash
cd ~/digital-kiosk
bash setup_autostart.sh
```

**If you just renamed it:**
```bash
mv ~/.config/autostart/kiosk.desktop.disabled ~/.config/autostart/kiosk.desktop
```

## Troubleshooting

### The kiosk doesn't start automatically
- **Check the startup log**: `cat ~/digital-kiosk/kiosk_startup.log`
  - This log shows what happened when the system tried to start the kiosk
  - Look for error messages about missing files or Python errors
- **Check X session errors**: `cat ~/.xsession-errors | tail -n 50`
  - This shows errors from the graphical desktop startup
- **Verify the file paths**: Make sure `kiosk.py` and `start_kiosk.sh` are in the correct location
- **Try running manually first**: `python3 /home/pi/digital-kiosk/kiosk.py`
  - If this works but autostart doesn't, the issue is likely timing-related
- **Increase the delay**: Edit `start_kiosk.sh` and change `sleep 10` to `sleep 15` or `sleep 20`
  - Some Raspberry Pis take longer to fully load the desktop environment

### I can't exit the full-screen window
- Try pressing `Alt+F4` first
- If that doesn't work, use `Ctrl+Alt+F1` to switch to terminal
- Login and run `sudo killall python3`
- Press `Ctrl+Alt+F7` to return to desktop

### The kiosk keeps coming back after I close it
- The autostart is still enabled
- Follow the "How to Disable Autostart Permanently" section above
- Don't forget to reboot after making changes!

### The time doesn't update
- Make sure the `window.after(1000, update_time)` line is in the code
- Check that you called `update_time()` before `window.mainloop()`

### The script won't run
- Make sure you have Python 3 installed: `python3 --version`
- tkinter should come with Python, but if not: `sudo apt-get install python3-tk`

### I forgot my password and can't log into the terminal
- You may need to reset your password using recovery mode
- Ask your teacher or instructor for help with this

## Learning Challenges

Try these challenges to learn more:

1. **Beginner**: Change the text color to your favorite color
2. **Beginner**: Change the text to say "Welcome [Your Name]"
3. **Intermediate**: Add the current date below the time
4. **Intermediate**: Change the font to a different style
5. **Intermediate**: Modify the rainbow to cycle faster (every hour instead of 24 hours)
6. **Advanced**: Add a temperature display (you'll need to research how to get system temperature)
7. **Advanced**: Make the rainbow cycle backwards (hint: reverse the hue calculation)
8. **Advanced**: Create a "pulsing" effect by slowly changing the brightness (value) over time

## Resources

- **Python tkinter documentation**: https://docs.python.org/3/library/tkinter.html
- **Raspberry Pi documentation**: https://www.raspberrypi.org/documentation/

## Need Help?

- Check the Troubleshooting section above
- Ask your teacher or instructor
- Search online for "Python tkinter tutorial" to learn more

---

**Have fun coding and customizing your kiosk!** 🚀
