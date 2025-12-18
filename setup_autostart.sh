#!/bin/bash

# Digital Kiosk Auto-Setup Script for Raspberry Pi Zero 2W
# This script automatically configures your Pi to run the kiosk on startup
# Uses a shell wrapper with delay for improved reliability

echo "================================================"
echo "   Pi Academy Digital Kiosk Setup Script"
echo "================================================"
echo ""

# Color codes for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KIOSK_FILE="$SCRIPT_DIR/kiosk.py"
STARTER_SCRIPT="$SCRIPT_DIR/start_kiosk.sh"

echo -e "${BLUE}Step 1: Checking for kiosk.py...${NC}"
if [ ! -f "$KIOSK_FILE" ]; then
    echo -e "${RED}Error: kiosk.py not found in $SCRIPT_DIR${NC}"
    echo "Please make sure kiosk.py is in the same folder as this setup script."
    exit 1
fi
echo -e "${GREEN}✓ Found kiosk.py at $KIOSK_FILE${NC}"
echo ""

echo -e "${BLUE}Step 2: Checking for start_kiosk.sh...${NC}"
if [ ! -f "$STARTER_SCRIPT" ]; then
    echo -e "${RED}Error: start_kiosk.sh not found in $SCRIPT_DIR${NC}"
    echo "Please make sure start_kiosk.sh is in the same folder as this setup script."
    exit 1
fi
echo -e "${GREEN}✓ Found start_kiosk.sh at $STARTER_SCRIPT${NC}"
echo ""

echo -e "${BLUE}Step 3: Making start_kiosk.sh executable...${NC}"
chmod +x "$STARTER_SCRIPT"
echo -e "${GREEN}✓ start_kiosk.sh is now executable${NC}"
echo ""

echo -e "${BLUE}Step 4: Checking Python 3 installation...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}Python 3 is not installed. Installing...${NC}"
    sudo apt-get update
    sudo apt-get install -y python3
else
    echo -e "${GREEN}✓ Python 3 is installed${NC}"
fi
echo ""

echo -e "${BLUE}Step 5: Checking tkinter installation...${NC}"
if ! python3 -c "import tkinter" &> /dev/null; then
    echo -e "${YELLOW}tkinter is not installed. Installing...${NC}"
    sudo apt-get install -y python3-tk
else
    echo -e "${GREEN}✓ tkinter is installed${NC}"
fi
echo ""

echo -e "${BLUE}Step 6: Creating autostart directory...${NC}"
# Use modern .desktop file method (works with all desktop environments)
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"
echo -e "${GREEN}✓ Directory created: $AUTOSTART_DIR${NC}"
echo ""

echo -e "${BLUE}Step 7: Creating .desktop autostart file...${NC}"
DESKTOP_FILE="$AUTOSTART_DIR/kiosk.desktop"

# Backup existing desktop file if it exists
if [ -f "$DESKTOP_FILE" ]; then
    echo "Backing up existing kiosk.desktop file..."
    cp "$DESKTOP_FILE" "$DESKTOP_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✓ Backup created${NC}"
fi

# Create the .desktop file
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Type=Application
Name=Digital Kiosk
Exec=$STARTER_SCRIPT
Comment=Starts the Python kiosk application with a 10s delay
Terminal=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chmod +x "$DESKTOP_FILE"
echo -e "${GREEN}✓ Desktop autostart file configured${NC}"
echo ""

echo -e "${BLUE}Step 8: Creating log directory for troubleshooting...${NC}"
echo "Logs will be written to: $SCRIPT_DIR/kiosk_startup.log"
echo -e "${GREEN}✓ Log file path configured${NC}"
echo ""

echo "================================================"
echo -e "${GREEN}          Setup Complete! 🎉${NC}"
echo "================================================"
echo ""
echo "The kiosk has been configured with improved startup logic:"
echo -e "${BLUE}• 10-second delay${NC} to ensure desktop is ready"
echo -e "${BLUE}• Detailed logging${NC} for troubleshooting"
echo -e "${BLUE}• Environment checks${NC} before starting"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Reboot your Raspberry Pi: sudo reboot"
echo "2. The kiosk will automatically start after ~10 seconds"
echo "3. Check logs if issues occur: cat $SCRIPT_DIR/kiosk_startup.log"
echo ""
echo -e "${YELLOW}To stop the kiosk:${NC}"
echo "- Press Alt+F4 to close the window"
echo "- Or switch to terminal (Ctrl+Alt+F1) and run: pkill python3"
echo ""
echo -e "${YELLOW}To disable auto-start:${NC}"
echo "rm ~/.config/autostart/kiosk.desktop"
echo ""
echo -e "${YELLOW}Troubleshooting:${NC}"
echo "- View startup logs: cat $SCRIPT_DIR/kiosk_startup.log"
echo "- View X session errors: cat ~/.xsession-errors | tail -n 50"
echo "- Check autostart file: cat ~/.config/autostart/kiosk.desktop"
echo ""
echo "Thank you for using Pi Academy Digital Kiosk! 🚀"
echo ""
