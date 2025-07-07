#!/bin/bash

# Script Instalasi Dependensi Gaming untuk Arch Linux
# Pastikan Chaotic-AUR sudah terinstal sebelumnya
# Jalankan dengan hak akses root (sudo)

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fungsi untuk menampilkan error
error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Cek user root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${YELLOW}Harap jalankan script ini dengan sudo!${NC}"
    exit 1
fi

# Update sistem terlebih dahulu
echo -e "${CYAN}[1/6] Memperbarui sistem...${NC}"
pacman -Syu --noconfirm || error "Gagal memperbarui sistem"

# Instal paket-paket dasar 64-bit
echo -e "${CYAN}[2/6] Menginstal paket dasar 64-bit...${NC}"
pacman -S --noconfirm --needed \
    steam \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    wine-staging \
    winetricks \
    lutris \
    gamemode \
    lib32-gamemode \
    mangohud \
    lib32-mangohud \
    giflib \
    lib32-giflib \
    gst-plugins-good \
    gst-plugins-bad \
    gst-plugins-ugly \
    gst-libav \
    lib32-gst-plugins-good \
    lib32-gst-plugins-bad \
    lib32-gst-plugins-ugly \
    lib32-gst-libav \
    vkd3d \
    lib32-vkd3d \
    dxvk-bin \
    lib32-dxvk-bin \
    || error "Gagal menginstal paket dasar"

# Instal paket dari Chaotic-AUR
echo -e "${CYAN}[3/6] Menginstal paket dari Chaotic-AUR...${NC}"
pacman -S --noconfirm --needed \
    vkbasalt \
    proton-ge-custom-bin \
    wine-ge-custom \
    lib32-vkbasalt \
    || error "Gagal menginstal paket dari Chaotic-AUR"

# Konfigurasi environment variables
echo -e "${CYAN}[4/6] Mengatur environment variables...${NC}"
if ! grep -q "GAMEMODERUN" /etc/environment; then
    echo -e "\n# Konfigurasi Gaming" >> /etc/environment
    echo "ENABLE_VKBASALT=1" >> /etc/environment
    echo "DXVK_CONFIG_FILE=/etc/dxvk.conf" >> /etc/environment
    echo "MANGOHUD=1" >> /etc/environment
    echo "MANGOHUD_CONFIG=fps_limit=0,position=top-left" >> /etc/environment
    echo -e "${YELLOW}Environment variables berhasil ditambahkan${NC}"
else
    echo -e "${YELLOW}Environment variables sudah ada${NC}"
fi

# Buat konfigurasi dasar VKBASALT
echo -e "${CYAN}[5/6] Membuat konfigurasi VKBASALT...${NC}"
cat > /etc/vkBasalt.conf << EOF
# Konfigurasi VKBASALT
effects = cas:fidelityfx
toggleKey = Home
enableOnLaunch = True
EOF

# Buat konfigurasi dasar DXVK
echo -e "${CYAN}[6/6] Membuat konfigurasi DXVK...${NC}"
cat > /etc/dxvk.conf << EOF
# Konfigurasi DXVK
dxgi.nvapiHack = False
d3d9.deferSurfaceCreation = True
d3d9.samplerAnisotropy = 16
EOF

echo -e "\n${GREEN}Instalasi berhasil!${NC}"
echo -e "Beberapa paket yang telah diinstal:"
echo -e "  ${YELLOW}Steam${NC}        : Client game Steam"
echo -e "  ${YELLOW}Proton GE${NC}    : Kompatibilitas game Windows (dari Chaotic-AUR)"
echo -e "  ${YELLOW}VKBASALT${NC}     : Peningkatan visual Vulkan (dari Chaotic-AUR)"
echo -e "  ${YELLOW}Wine-GE${NC}      : Implementasi Wine khusus gaming (dari Chaotic-AUR)"
echo -e "  ${YELLOW}Lutris${NC}       : Platform manajemen game"
echo -e "  ${YELLOW}Gamemode${NC}     : Optimasi performa saat gaming"
echo -e "  ${YELLOW}MangoHud${NC}     : Overlay monitoring performa"
echo -e "  ${YELLOW}DXVK${NC}         : Implementasi Vulkan untuk DirectX"

echo -e "\n${CYAN}Konfigurasi tambahan:${NC}"
echo -e "1. VKBASALT diaktifkan secara global (dinonaktifkan dengan tombol Home)"
echo -e "2. MangoHud diaktifkan dengan konfigurasi default"
echo -e "3. DXVK telah dikonfigurasi untuk performa optimal"
echo -e "4. Variabel lingkungan telah ditambahkan ke /etc/environment"

echo -e "\n${YELLOW}Setelah reboot, semua konfigurasi akan berlaku!${NC}"
