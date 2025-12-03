# 🖥️ Pi Academy Digital Kiosk

Welcome! This project helps you create a cool digital kiosk display on your Raspberry Pi that shows a welcome message with a live updating clock.

## What Does This Do?

This Python program creates a full-screen blue window that displays:
- A welcome message: "WELCOME TO THE PI ACADEMY KIOSK!"
- A live clock that updates every second
- The time is shown in 12-hour format (with AM/PM)

## What You Need

- **Raspberry Pi Zero 2W** (or any Raspberry Pi)
- **Raspberry Pi OS** (with desktop) installed
- **Monitor/Display** connected to your Pi
- **Keyboard and mouse** (for initial setup)

## Files in This Project

- `kiosk.py` - The main Python program that creates the kiosk display
- `start_kiosk.sh` - Shell wrapper script with delay and error logging
- `setup_autostart.sh` - Automatic setup script for Raspberry Pi Zero 2W autostart
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
```
- `tkinter` - Creates windows and graphics (comes with Python!)
- `datetime` - Gets the current time and date

### The Update Function
```python
def update_time():
    current_time = datetime.now().strftime("%I:%M:%S %p")
    new_message = f"WELCOME TO THE PI ACADEMY KIOSK!\n\n{current_time}"
    message.config(text=new_message)
    window.after(1000, update_time)
```
This function:
1. Gets the current time
2. Formats it to look nice (example: "02:30:45 PM")
3. Updates the message on screen
4. Schedules itself to run again in 1 second (1000 milliseconds)

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
    bg="blue"
)
message.pack(expand=True, fill='both')
```
This creates the text label with:
- White text (`fg="white"`)
- Blue background (`bg="blue"`)
- Large font (size 32)
- Text centered in the window

## Customization Ideas

Want to make it your own? Try changing these:

### Change the Colors
```python
message = tk.Label(
    text="Initializing Time...",
    font=("Helvetica", 32),
    fg="yellow",      # Try: "red", "green", "black", "purple"
    bg="darkgreen"    # Try: "orange", "purple", "black", "white"
)
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
   mkdir -p ~/.config/lxsession/LXDE-pi
   ```

2. Create the shell wrapper script (recommended for stability):
   ```bash
   nano ~/digital-kiosk/start_kiosk.sh
   ```

   Add this content:
   ```bash
   #!/bin/bash
   sleep 10  # Wait for desktop to fully load
   python3 /home/pi/digital-kiosk/kiosk.py
   ```

3. Make it executable:
   ```bash
   chmod +x ~/digital-kiosk/start_kiosk.sh
   ```

4. Edit the autostart file:
   ```bash
   nano ~/.config/lxsession/LXDE-pi/autostart
   ```

5. Add this line at the end:
   ```
   @/home/pi/digital-kiosk/start_kiosk.sh
   ```

6. Save and exit:
   - Press `Ctrl+X`
   - Press `Y` (for "yes")
   - Press `Enter`

7. Reboot:
   ```bash
   sudo reboot
   ```

**Why use a shell wrapper?** The 10-second delay ensures the desktop environment is fully loaded before the kiosk starts, which prevents many common autostart issues.

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

### Easy Method: Using Terminal

1. **Exit the kiosk** using one of the methods above to get back to the desktop

2. **Open Terminal** (click the black terminal icon at the top)

3. **Open the autostart file** for editing:
   ```bash
   nano ~/.config/lxsession/LXDE-pi/autostart
   ```

4. **Disable the kiosk line** by adding a `#` symbol in front of it:
   ```
   @lxpanel --profile LXDE-pi
   #@python3 /home/pi/kiosk.py
   ```

   The `#` symbol tells the computer to ignore that line. You can also completely delete the line if you prefer.

5. **Save and exit**:
   - Press `Ctrl+X`
   - Press `Y` (for "yes, save changes")
   - Press `Enter`

6. **Reboot** to test:
   ```bash
   sudo reboot
   ```

Now your Pi will boot to the normal desktop without the kiosk starting automatically!

### Re-enabling Autostart

To make the kiosk start automatically again, just remove the `#` symbol:

1. Open the file: `nano ~/.config/lxsession/LXDE-pi/autostart`
2. Change `#@python3 /home/pi/kiosk.py` back to `@python3 /home/pi/kiosk.py`
3. Save and reboot

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

1. **Beginner**: Change the background color to your favorite color
2. **Beginner**: Change the text to say "Welcome [Your Name]"
3. **Intermediate**: Add the current date below the time
4. **Intermediate**: Change the font to a different style
5. **Advanced**: Add a temperature display (you'll need to research how to get system temperature)
6. **Advanced**: Make the background color change every 5 seconds

## Resources

- **Python tkinter documentation**: https://docs.python.org/3/library/tkinter.html
- **Raspberry Pi documentation**: https://www.raspberrypi.org/documentation/

## Need Help?

- Check the Troubleshooting section above
- Ask your teacher or instructor
- Search online for "Python tkinter tutorial" to learn more

---

**Have fun coding and customizing your kiosk!** 🚀
