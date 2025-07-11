#!/bin/bash

# Script Instalasi Zsh + Powerlevel10k + Plugins untuk Arch Linux
# Pastikan Anda menjalankan script ini sebagai user biasa (bukan root)
# Script ini akan meminta password sudo ketika diperlukan

# Fungsi untuk menampilkan pesan status
info() {
  echo -e "\e[1;34m[*]\e[0m $1"
}

success() {
  echo -e "\e[1;32m[+]\e[0m $1"
}

error() {
  echo -e "\e[1;31m[!]\e[0m $1"
}

# Memastikan pacman tersedia
if ! command -v pacman &> /dev/null; then
  error "Script ini hanya untuk Arch Linux dan turunannya!"
  exit 1
fi

# Memastikan dijalankan sebagai user biasa
if [ $(id -u) -eq 0 ]; then
  error "Jangan jalankan script ini sebagai root/sudo!"
  echo "Jalankan sebagai user biasa, password akan diminta jika diperlukan"
  exit 1
fi

# Update sistem
info "Memperbarui sistem..."
sudo pacman -Syu --noconfirm

# Instalasi paket utama
info "Menginstal paket utama: zsh git curl unzip"
sudo pacman -S --noconfirm zsh git curl unzip

# Instalasi Oh My Zsh
info "Menginstal Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Instalasi Powerlevel10k
info "Menginstal tema Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Instalasi plugin
info "Menginstal plugin..."
# Zsh Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Zsh Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Zsh History Substring Search
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Konfigurasi .zshrc
info "Mengkonfigurasi .zshrc..."

# Backup .zshrc jika sudah ada
if [ -f ~/.zshrc ]; then
  mv ~/.zshrc ~/.zshrc.bak
  info "File .zshrc lama telah dibackup ke .zshrc.bak"
fi

# Membuat .zshrc baru
cat > ~/.zshrc << EOF
# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin
plugins=(
  git
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  history
)

source \$ZSH/oh-my-zsh.sh

# Powerlevel10k Configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User Configuration
HIST_STAMPS="dd/mm/yyyy"
HISTSIZE=5000
SAVEHIST=5000
EOF

# Instalasi font (optional)
read -p "Unduh dan instal font Meslo Nerd Font? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  info "Mengunduh font Meslo Nerd Font..."
  mkdir -p ~/.local/share/fonts
  cd ~/.local/share/fonts
  curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  curl -fLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  fc-cache -fv
  success "Font instalasi selesai!"
  info "Anda mungkin perlu mengatur font terminal secara manual"
fi

# Konfigurasi Powerlevel10k
info "Setup Powerlevel10k akan berjalan saat pertama kali zsh dijalankan"
success "Instalasi selesai!"

# Ganti shell default ke zsh
chsh -s $(which zsh)
info "Shell default telah diubah ke zsh"

# Jalankan zsh untuk setup awal
info "Jalankan zsh untuk menyelesaikan setup:"
echo "exec zsh"
exec zsh
