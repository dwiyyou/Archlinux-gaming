#!/bin/bash

# Script: update-mirrors
# Description: Update Arch Linux mirrorlist using reflector for fastest mirrors
# Author: Your Name
# License: MIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if reflector is installed
if ! command -v reflector &> /dev/null; then
    echo -e "${RED}Error: reflector is not installed.${NC}"
    echo -e "Install it with: ${YELLOW}sudo pacman -S reflector${NC}"
    exit 1
fi

# Backup current mirrorlist
echo -e "${YELLOW}Backing up current mirrorlist to /etc/pacman.d/mirrorlist.backup...${NC}"
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# Countries to use (prioritize nearby countries)
COUNTRIES=(
    "Indonesia"
    "Singapore"
    "Malaysia"
    "Japan"
    "Australia"
)

# Run reflector with optimal parameters
echo -e "${GREEN}Finding fastest mirrors...${NC}"
sudo reflector \
    --country "${COUNTRIES[*]}" \
    --latest 20 \
    --protocol https \
    --sort rate \
    --age 12 \
    --download-timeout 5 \
    --fastest 10 \
    --save /etc/pacman.d/mirrorlist

# Verify the new mirrorlist
echo -e "${YELLOW}New mirrorlist:${NC}"
head -n 20 /etc/pacman.d/mirrorlist

# Update package database
echo -e "${GREEN}Updating package database...${NC}"
sudo pacman -Syyu --noconfirm

echo -e "${GREEN}Mirrorlist updated successfully!${NC}"
