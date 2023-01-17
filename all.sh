#!/bin/bash

cd $(dirname $0)

if [ -e /boot/grub2/grub.cfg ]; then
    GRUB_CFG=/boot/grub2/grub.cfg
    echo $GRUB_CFG
elif [ -e /boot/efi/EFI/centos/grub.cfg ]; then
    GRUB_CFG=/boot/efi/EFI/centos/grub.cfg
    echo $GRUB_CFG
fi

kernel_num=$(rpm -qa | egrep 'kernel-4.14.49|kernel-devel-4.14.49' | wc -l)
#if rpm -q kernel-4.14.49 &> /dev/null; then
if [ $kernel_num -eq 2 ]; then
    echo '内核升级完成' && exit
fi

raid_num=$(lspci | grep RAID | grep 39xx | wc -l)

if [ $raid_num -eq 1 ]; then
    cp $GRUB_CFG{,.bak}
    rpm -ivh kernel-4.14.49-1.x86_64.rpm
    rpm -ivh kernel-devel-4.14.49-1.x86_64.rpm
    rpm -ivh kernel-headers-4.14.49-1.x86_64.rpm
    rpm -ivh kernel-4.14.49-1.src.rpm
    #grub2-editenv list
    grub2-set-default "CentOS Linux (4.14.49) 7 (Core)"
    #sed -i 's/CentOS Linux (3.10.0-1127.el7.x86_64) 7 (Core)/CentOS Linux (4.14.49) 7 (Core)/g' /boot/ efi/EFI/centos/grubenv
    grub2-mkconfig -o $GRUB_CFG
    grub2-editenv list

elif [ $raid_num -eq 0 ]; then
    cp $GRUB_CFG{,.bak}
    rpm -ivh kernel-4.14.49.x86_64.rpm
    rpm -ivh kernel-devel-4.14.49.x86_64.rpm
    grub2-set-default "CentOS Linux (4.14.49) 7 (Core)"
    grub2-mkconfig -o $GRUB_CFG
    grub2-editenv list

fi
