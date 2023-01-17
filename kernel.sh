#!/bin/bash

cd $(dirname $0)

GRUB_CFG=/boot/grub2/grub.cfg

if rpm -q kernel-4.14.49 &>/dev/null; then
  exit
fi
cp $GRUB_CFG{,.bak}
rpm -ivh kernel-4.14.49-1.x86_64.rpm
rpm -ivh kernel-devel-4.14.49-1.x86_64.rpm
sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=0/g' /etc/default/grub
grub2-mkconfig -o $GRUB_CFG
mv /boot/grub2/grubenv{,.bak}


#saved_entry=CentOS Linux (3.10.0-1127.el7.x86_64) 7 (Core)


#手动执行步骤
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2-efi.cfg

rpm -ivh kernel-4.14.49-1.x86_64.rpm
rpm -ivh kernel-devel-4.14.49-1.x86_64.rpm

grub2-editenv list
grub2-set-default "CentOS Linux (4.14.49) 7 (Core)"

vi /etc/default/grub
GRUB_DEFAULT=0
grub2-mkconfig -o /boot/grub2/grub.cfg #update
#shutdown -r now

vim /boot/efi/EFI/centos/grubenv
#saved_entry=CentOS Linux (4.14.49) 7 (Core)

grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg

grubby --default-kernel | grep 4.14.49

#shutdown -r now

#刷新dracut
vim /etc/dracut.conf
add_drivers+="mpt3sas"

dracut -f /boot/initramfs-4.14.49.img 4.14.49

lsinitrd -k 4.14.49 | grep mpt3sas

#reboot

#https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/
# search  linux-4.14.49.tar.gz
