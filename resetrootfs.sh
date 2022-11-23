#!/bin/bash

# copy bin
./torootfs.sh bash
./torootfs.sh chown
./torootfs.sh gzip
./torootfs.sh less
./torootfs.sh mount
./torootfs.sh netstat
./torootfs.sh rm
./torootfs.sh tabs
./torootfs.sh tee
./torootfs.sh top
./torootfs.sh tty
./torootfs.sh cat
./torootfs.sh cp
./torootfs.sh hostname
./torootfs.sh ln
./torootfs.sh mountpoint
./torootfs.sh ping
./torootfs.sh sed
./torootfs.sh tac
./torootfs.sh test
./torootfs.sh touch
./torootfs.sh umount
./torootfs.sh chgrp
./torootfs.sh echo
./torootfs.sh ip
./torootfs.sh ls
./torootfs.sh mv
./torootfs.sh ps
./torootfs.sh sh
./torootfs.sh tail
./torootfs.sh timeout
./torootfs.sh tr
./torootfs.sh uname
./torootfs.sh chmod
./torootfs.sh grep
./torootfs.sh kill
./torootfs.sh more
./torootfs.sh nc
./torootfs.sh pwd
./torootfs.sh sleep
./torootfs.sh tar
./torootfs.sh toe
./torootfs.sh truncate
./torootfs.sh which
./torootfs.sh awk
./torootfs.sh env
./torootfs.sh groups
./torootfs.sh head
./torootfs.sh id
./torootfs.sh mesg
./torootfs.sh sort
./torootfs.sh strace
./torootfs.sh tail
./torootfs.sh top
./torootfs.sh uniq
./torootfs.sh vi
./torootfs.sh wc
./torootfs.sh xargs


# copy etc
mkdir -p ./rootfs/etc
cp /etc/bash.bashrc ./rootfs/etc/
cp /etc/group ./rootfs/etc/
cp /etc/hostname ./rootfs/etc/
cp /etc/hosts ./rootfs/etc/
cp /etc/ld.so.cache ./rootfs/etc/
cp /etc/nsswitch.conf ./rootfs/etc/
cp /etc/passwd ./rootfs/etc/
cp /etc/profile ./rootfs/etc/
cp /etc/resolv.conf ./rootfs/etc/
cp /etc/shadow ./rootfs/etc/

# create conf
mkdir -p ./conf
cp /etc/hostname ./conf
cp /etc/hosts ./conf
cp /etc/resolv.conf ./conf

# create dir
mkdir -p ./rootfs/proc
mkdir -p ./rootfs/sys
mkdir -p ./rootfs/tmp
mkdir -p ./rootfs/dev
mkdir -p ./rootfs/dev/pts
mkdir -p ./rootfs/shm
mkdir -p ./rootfs/run
mkdir -p /tmp/t1
mkdir -p ./rootfs/mnt

# umount
umount -v ./rootfs/proc
umount -v ./rootfs/sys
umount -v ./rootfs/tmp
umount -v ./rootfs/dev/*
umount -v ./rootfs/dev
umount -v ./rootfs/shm
umount -v ./rootfs/run
umount -v ./rootfs/mnt
