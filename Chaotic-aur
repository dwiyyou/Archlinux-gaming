#!/bin/bash

# Script Auto-Install Chaotic-AUR untuk Arch Linux
# Pastikan menjalankan script ini dengan hak akses root (sudo)

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Langkah 1: Pasang kunci GPG
echo -e "${GREEN}[1/4] Memasang kunci GPG...${NC}"
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com || error "Gagal menerima kunci"
pacman-key --lsign-key FBA220DFC880C036 || error "Gagal menandatangani kunci"

# Langkah 2: Pasang paket chaotic-keyring dan mirrorlist
echo -e "${GREEN}[2/4] Menginstal chaotic-keyring dan mirrorlist...${NC}"
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' || error "Gagal menginstal paket"

# Langkah 3: Konfigurasi pacman.conf
echo -e "${GREEN}[3/4] Mengkonfigurasi /etc/pacman.conf...${NC}"
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo -e "\n[chaotic-aur]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
    echo -e "${YELLOW}Repositori Chaotic-AUR berhasil ditambahkan ke pacman.conf${NC}"
else
    echo -e "${YELLOW}Repositori Chaotic-AUR sudah ada di pacman.conf${NC}"
fi

# Langkah 4: Update database paket
echo -e "${GREEN}[4/4] Memperbarui database paket...${NC}"
pacman -Sy --noconfirm || error "Gagal memperbarui database"

echo -e "\n${GREEN}Chaotic-AUR berhasil diinstal!${NC}"
echo -e "Anda sekarang dapat menginstal paket dari repositori Chaotic-AUR"
echo -e "Contoh: ${YELLOW}pacman -S <nama-paket>${NC}"
