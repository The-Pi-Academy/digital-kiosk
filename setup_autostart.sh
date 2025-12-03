#!/bin/bash

# Digital Kiosk Auto-Setup Script for Raspberry Pi Zero 2W
# This script automatically configures your Pi to run the kiosk on startup

echo "================================================"
echo "   Pi Academy Digital Kiosk Setup Script"
echo "================================================"
echo ""

# Color codes for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KIOSK_FILE="$SCRIPT_DIR/kiosk.py"

echo -e "${BLUE}Step 1: Checking for kiosk.py...${NC}"
if [ ! -f "$KIOSK_FILE" ]; then
    echo -e "${YELLOW}Error: kiosk.py not found in $SCRIPT_DIR${NC}"
    echo "Please make sure kiosk.py is in the same folder as this setup script."
    exit 1
fi
echo -e "${GREEN}✓ Found kiosk.py at $KIOSK_FILE${NC}"
echo ""

echo -e "${BLUE}Step 2: Checking Python 3 installation...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}Python 3 is not installed. Installing...${NC}"
    sudo apt-get update
    sudo apt-get install -y python3
else
    echo -e "${GREEN}✓ Python 3 is installed${NC}"
fi
echo ""

echo -e "${BLUE}Step 3: Checking tkinter installation...${NC}"
if ! python3 -c "import tkinter" &> /dev/null; then
    echo -e "${YELLOW}tkinter is not installed. Installing...${NC}"
    sudo apt-get install -y python3-tk
else
    echo -e "${GREEN}✓ tkinter is installed${NC}"
fi
echo ""

echo -e "${BLUE}Step 4: Testing the kiosk script...${NC}"
if python3 "$KIOSK_FILE" &> /dev/null & then
    KIOSK_PID=$!
    sleep 2
    kill $KIOSK_PID 2>/dev/null
    echo -e "${GREEN}✓ Kiosk script runs successfully${NC}"
else
    echo -e "${YELLOW}Warning: There might be an issue with the kiosk script${NC}"
    echo "Continuing anyway..."
fi
echo ""

echo -e "${BLUE}Step 5: Creating autostart directory...${NC}"
AUTOSTART_DIR="$HOME/.config/lxsession/LXDE-pi"
mkdir -p "$AUTOSTART_DIR"
echo -e "${GREEN}✓ Directory created: $AUTOSTART_DIR${NC}"
echo ""

echo -e "${BLUE}Step 6: Configuring autostart file...${NC}"
AUTOSTART_FILE="$AUTOSTART_DIR/autostart"

# Backup existing autostart file if it exists
if [ -f "$AUTOSTART_FILE" ]; then
    echo "Backing up existing autostart file..."
    cp "$AUTOSTART_FILE" "$AUTOSTART_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✓ Backup created${NC}"
fi

# Create the autostart file
cat > "$AUTOSTART_FILE" << EOF
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash
@python3 $KIOSK_FILE
EOF

echo -e "${GREEN}✓ Autostart file configured${NC}"
echo ""

echo -e "${BLUE}Step 7: Making kiosk.py executable...${NC}"
chmod +x "$KIOSK_FILE"
echo -e "${GREEN}✓ kiosk.py is now executable${NC}"
echo ""

echo "================================================"
echo -e "${GREEN}          Setup Complete! 🎉${NC}"
echo "================================================"
echo ""
echo "The kiosk has been configured to start automatically"
echo "when your Raspberry Pi boots up."
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Reboot your Raspberry Pi: sudo reboot"
echo "2. The kiosk will automatically start in full-screen"
echo ""
echo -e "${YELLOW}To stop the kiosk:${NC}"
echo "- Press Alt+F4 to close the window"
echo "- Or switch to terminal (Ctrl+Alt+F1) and run: pkill python3"
echo ""
echo -e "${YELLOW}To disable auto-start:${NC}"
echo "Edit: $AUTOSTART_FILE"
echo "Remove the line: @python3 $KIOSK_FILE"
echo ""
echo -e "${BLUE}Backup location:${NC} $AUTOSTART_FILE.backup.*"
echo ""
echo "Thank you for using Pi Academy Digital Kiosk! 🚀"
echo ""
