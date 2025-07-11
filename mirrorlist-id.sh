#!/bin/bash

set -e

echo "===> Membackup mirrorlist lama ke /etc/pacman.d/mirrorlist.backup..."
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

echo "===> Mengganti mirrorlist dengan mirror dari Indonesia..."

sudo tee /etc/pacman.d/mirrorlist > /dev/null <<EOF
##
## Arch Linux repository mirrorlist
## Filtered by mirror score from mirror status page
## Generated on 2025-07-11
##

## Indonesia
Server = http://kebo.pens.ac.id/archlinux/\$repo/os/\$arch
## Indonesia
Server = http://mirror.ditatompel.com/archlinux/\$repo/os/\$arch
## Indonesia
Server = https://kacabenggala.uny.ac.id/archlinux/\$repo/os/\$arch
## Indonesia
Server = http://mirror.citrahost.com/archlinux/\$repo/os/\$arch
## Indonesia
Server = https://mirror.ditatompel.com/archlinux/\$repo/os/\$arch
## Indonesia
Server = https://mirror.citrahost.com/archlinux/\$repo/os/\$arch
EOF

echo "✅ Mirrorlist Indonesia berhasil diterapkan!"
echo "👉 Kamu bisa uji kecepatannya dengan 'sudo pacman -Syy' lalu install sesuatu."
