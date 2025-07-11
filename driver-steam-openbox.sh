#!/bin/bash

set -e

echo "===> Updating system..."
sudo pacman -Syu --noconfirm

echo "===> Installing Openbox and basic components..."
sudo pacman -S --noconfirm xorg-server xorg-xinit openbox obconf lxappearance \
    nitrogen picom tint2 rofi thunar thunar-volman thunar-archive-plugin file-roller gvfs

echo "===> Installing audio support (PipeWire)..."
sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol

echo "===> Installing network manager GUI..."
sudo pacman -S --noconfirm network-manager-applet

echo "===> Enabling NetworkManager..."
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "===> Installing AMD GPU drivers (RX 580)..."
sudo pacman -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
    lib32-vulkan-icd-loader vulkan-icd-loader xf86-video-amdgpu

echo "===> Installing Steam and gaming dependencies..."
sudo pacman -S --noconfirm steam steam-native-runtime gamemode mangohud

echo "===> Installing Lutris and Wine..."
sudo pacman -S --noconfirm lutris wine winetricks wine-gecko wine-mono

echo "===> Installing fonts..."
sudo pacman -S --noconfirm ttf-dejavu ttf-liberation ttf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji

echo "===> Setting up .xinitrc for Openbox..."
cat <<EOF > ~/.xinitrc
#!/bin/bash
exec openbox-session
EOF
chmod +x ~/.xinitrc

echo "===> Creating Openbox autostart for panel and compositor..."
mkdir -p ~/.config/openbox

cat <<EOF > ~/.config/openbox/autostart
nitrogen --restore &
picom --config ~/.config/picom/picom.conf &
tint2 &
nm-applet &
EOF

echo "===> Creating sample picom.conf..."
mkdir -p ~/.config/picom
cat <<EOF > ~/.config/picom/picom.conf
backend = "glx";
vsync = true;
corner-radius = 6;
shadow = true;
shadow-radius = 12;
shadow-offset-x = -15;
shadow-offset-y = -15;
shadow-opacity = 0.5;
EOF

echo "===> Installation complete!"
echo "✅ Jalankan 'startx' untuk masuk ke Openbox."
