#!/bin/bash

# Script Instalasi Driver AMD RX 580 dan Optimasi Intel i5-3570
# Jalankan dengan hak akses root (sudo)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${YELLOW}Harap jalankan script ini dengan sudo!${NC}"
        exit 1
    fi
}

install_drivers() {
    echo -e "${CYAN}[1/5] Memperbarui sistem...${NC}"
    pacman -Syu --noconfirm || error "Gagal memperbarui sistem"

    echo -e "${CYAN}[2/5] Menginstal driver AMD RX 580...${NC}"
    pacman -S --noconfirm --needed \
        mesa \
        lib32-mesa \
        vulkan-radeon \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        lib32-libva-mesa-driver \
        mesa-vdpau \
        lib32-mesa-vdpau \
        vulkan-icd-loader \
        lib32-vulkan-icd-loader \
        xf86-video-amdgpu \
        || error "Gagal menginstal driver AMD"

    echo -e "${CYAN}[3/5] Menginstal driver untuk Intel i5-3570...${NC}"
    pacman -S --noconfirm --needed \
        intel-ucode \
        mesa \
        lib32-mesa \
        vulkan-intel \
        lib32-vulkan-intel \
        libva-intel-driver \
        lib32-libva-intel-driver \
        intel-media-driver \
        || error "Gagal menginstal driver Intel"
}

configure_system() {
    echo -e "${CYAN}[4/5] Konfigurasi sistem...${NC}"
    
    # Konfigurasi GRUB untuk AMDGPU
    if ! grep -q "amdgpu" /etc/default/grub; then
        sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&radeon.si_support=0 amdgpu.si_support=1 /' /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg
        echo -e "${YELLOW}Parameter kernel AMDGPU ditambahkan ke GRUB${NC}"
    fi
    
    # Konfigurasi Xorg untuk AMD
    cat > /etc/X11/xorg.conf.d/20-amdgpu.conf << EOF
Section "Device"
    Identifier "AMD"
    Driver "amdgpu"
    Option "TearFree" "true"
    Option "DRI" "3"
    Option "VariableRefresh" "true"
EndSection
EOF

    # Konfigurasi Vulkan untuk prefer AMD
    cat > /etc/environment << EOF
AMD_VULKAN_ICD=RADV
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
EOF

    # Konfigurasi performa CPU Intel
    cat > /etc/default/cpupower << EOF
governor='performance'
max_perf_pct=100
min_perf_pct=100
EOF

    # Aktifkan service
    systemctl enable cpupower.service
}

install_utils() {
    echo -e "${CYAN}[5/5] Menginstal utilitas...${NC}"
    pacman -S --noconfirm --needed \
        libva-utils \
        vdpauinfo \
        vulkan-tools \
        clinfo \
        cpupower \
        mesa-demos \
        || error "Gagal menginstal utilitas"
}

show_info() {
    echo -e "\n${GREEN}Instalasi selesai!${NC}"
    echo -e "\n${CYAN}Driver yang diinstal:${NC}"
    echo -e "• ${YELLOW}AMDGPU${NC}: Driver grafis untuk RX 580"
    echo -e "• ${YELLOW}Mesa${NC}: Implementasi OpenGL/Vulkan"
    echo -e "• ${YELLOW}Intel-ucode${NC}: Microcode update untuk i5-3570"
    echo -e "• ${YELLOW}Vulkan-Radeon${NC}: Driver Vulkan untuk AMD"
    echo -e "• ${YELLOW}Vulkan-Intel${NC}: Driver Vulkan untuk iGPU Intel (jika digunakan)"
    
    echo -e "\n${CYAN}Konfigurasi yang diterapkan:${NC}"
    echo -e "• Prioritas Vulkan diatur ke AMD"
    echo -e "• Mode performa CPU diatur ke 'performance'"
    echo -e "• TearFree dan VRR diaktifkan untuk AMD"
    echo -e "• Parameter kernel AMDGPU ditambahkan"
    
    echo -e "\n${CYAN}Verifikasi instalasi:${NC}"
    echo -e "1. Cek OpenGL: ${YELLOW}glxinfo | grep 'OpenGL renderer'${NC}"
    echo -e "2. Cek Vulkan: ${YELLOW}vulkaninfo --summary | grep 'GPU id'${NC}"
    echo -e "3. Cek VA-API: ${YELLOW}vainfo | grep 'vainfo: VA-API'${NC}"
    echo -e "4. Cek mode CPU: ${YELLOW}cpupower frequency-info | grep 'governor'${NC}"
    
    echo -e "\n${YELLOW}Harap reboot sistem untuk menerapkan semua perubahan!${NC}"
}

# Main process
check_root
install_drivers
configure_system
install_utils
show_info
