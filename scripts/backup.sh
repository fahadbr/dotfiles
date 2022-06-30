#!/bin/bash

set -eu

backsrc=/mnt/backup

lvcreate -L 20G -n snap-root -s linuxvg/arch
trap "lvremove linuxvg/snap-root" SIGINT SIGQUIT EXIT

mount /dev/linuxvg/snap-root $backsrc
trap "umount /dev/linuxvg/snap-root" SIGINT SIGQUIT EXIT

exclude_file=/tmp/backup_exclude_file

cat >$exclude_file <<EOF
/tmp/*
$backdest/
/var/cache/pacman/pkg/
EOF

# full system backup

# Labels for backup name
#PC=${HOSTNAME}
pc=xps
distro=arch
type=full
date=$(date "+%F")
backupfile="$backdest/$distro-$type-$date.tar.gz"


# Check if exclude file exists
if [ ! -f $exclude_file ]; then
  echo -n "No exclude file exists, continue? (y/n): "
  read continue
  if [ $continue == "n" ]; then exit; fi
fi

# Check if chrooted prompt.
echo -n "backsrc=$backsrc; backdest=$backdest; backupfile=$backupfile - Are you ready to backup? (y/n): "
read executeback

if [ $executeback = "y" ]; then
  # -p, --acls and --xattrs store all permissions, ACLs and extended attributes. 
  # Without both of these, many programs will stop working!
  # It is safe to remove the verbose (-v) flag. If you are using a 
  # slow terminal, this can greatly speed up the backup process.
  # Use bsdtar because GNU tar will not preserve extended attributes.
  bsdtar --exclude-from=$exclude_file --one-file-system --acls --xattrs -cpvf $backupfile /
fi

