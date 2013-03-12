From: "David H. Rhodes Clymer" <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: bsetup
Date: Tue, 12 Mar 2013 00:31:54 -0400
Message-ID: <20130312043154.GB30795@mandarb.home.zettazebra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I've written the following bit if ugliness to ease the tedium of
doing setup/teardown of bcache devices. This is particularly handy
when testing things. Anyway, here it is, in the odd chance that it
might make things easier for anyone else.

-davidc

#!/bin/sh

action=$1

CREATE_LOG=bcache_create.log
DESTROY_LOG=bcache_destroy.log


case $action in
  create)
    [ -z "$2" ] && { echo "Error: Missing backing device."; exit 1; }
    [ -b "$2" ] || { echo "Error: Invalid backing device."; exit 1; }
    BACKING_DEV=$(readlink -e $2)
    CACHE_DEV=$(readlink -e $3)
    MNTPOINT=$4

    backing_part=$(basename $BACKING_DEV)
    backing_root=$(basename $BACKING_DEV |sed -e 's/(md|sd[a-z])[0-9]/\\1/g')
    if [ "$backing_part" = "$backing_root" ]; then
        backing_part=
    fi
    backing_sysfs_bcache=/sys/block/$backing_root/${backing_part:+${backing_part}/}/bcache/

    [ -d "$backing_sysfs_bcache" ] && { echo "Error: $BACKING_DEV is already a registered bcache device."; exit 1; }

    cache_set=$(ls -1 /sys/fs/bcache |grep -v register |head -n1)
    if [ -n "$CACHE_DEV" -a -z "$cache_set" ]; then
      [ -b "$CACHE_DEV" ] || { echo "Error: Invalid cache device."; exit 1; }
      cache_part=$(basename $CACHE_DEV)
      cache_root=$(basename $CACHE_DEV |sed -e 's/[0-9]//g')
      cache_sysfs_bcache=/sys/block/$cache_root/$cache_part/bcache/
      [ -d "$cache_sysfs_bcache" ] && { echo "Error: $CACHE_DEV is already a registered bcache device."; exit 1; }

      echo "Initializing cache device..."
      make-bcache -C --writeback $CACHE_DEV > "$CREATE_LOG" 2>&1
      echo $CACHE_DEV > /sys/fs/bcache/register
    else
      [ -z "$cache_set" ] && { echo "Error: Missing cache device."; exit 1; }
      echo "Using existing cache set: $cache_set"
    fi
	
    echo "Initializing backing device..."
    make-bcache -B --writeback $BACKING_DEV > "$CREATE_LOG" 2>&1
    echo $BACKING_DEV > /sys/fs/bcache/register
    # It seems that this can take a small amount of time. Wait, to ensure
    # that the devices are properly registered
    sleep 2
    echo "Creating bcache device..."
    cache_set=$(ls -1 /sys/fs/bcache |grep -v register |head -n1)
    echo $cache_set > $backing_sysfs_bcache/attach
    # It seems that this can take a small amount of time. Wait, to ensure
    # that the bcache device is set up.
    sleep 2
    bcache_dev=$(basename $(readlink ${backing_sysfs_bcache}/dev))
    if [ -n "$bcache_dev" ]; then
      echo "Device $bcache_dev created."
      if [ -n "$MNTPOINT" -a -d "$MNTPOINT" ]; then
        echo "Creating filesystem..."
        mkfs.ext4 /dev/$bcache_dev > "$CREATE_LOG" 2>&1
        tune2fs -o journal_data_writeback /dev/$bcache_dev
        echo "Mounting on $MNTPOINT"
        mount /dev/$bcache_dev $MNTPOINT > "$CREATE_LOG" 2>&1
      fi
      echo "done."
    else
      echo "Error: No bcache dev found"
      exit 1
    fi
  ;;

  destroy)
    [ -z "$2" ] && { echo "Error: Missing device."; exit 1; }
    dev=$2
    if [ "${dev#/dev/bcache}" != "$dev" ]; then
      [ -b "$dev" ] || { echo "Error: Invalid bcache device."; exit 1; }
      BCACHE_DEV=$dev
      bcache_part=$(basename $BCACHE_DEV)
      for bdev in /sys/block/$bcache_part/bcache/cache/bdev*; do
         BACKING_DEV="/dev/$(basename $(dirname $(readlink $bdev))) $BACKING_DEV"
      done
      CACHE_DEV=/dev/$(basename $(dirname $(readlink /sys/block/$bcache_part/bcache/cache/cache0)))
    else
      [ -b "$dev" ] || { echo "Error: Invalid backing device."; exit 1; }
      BACKING_DEV=$2
    fi

    if [ -n "$MNTPOINT" -a -d "$MNTPOINT" ]; then
      echo "Unmounting device..."
      umount "$MNTPOINT" > "$DESTROY_LOG" 2>&1
    fi

    for bdev in $BACKING_DEV; do
      backing_part=$(basename $bdev)
      backing_root=$(basename $BACKING_DEV |sed -e 's/(md|sd[a-z])[0-9]/\\1/g')
      if [ "$backing_part" = "$backing_root" ]; then
          backing_part=
      fi
      backing_sysfs_bcache=/sys/block/$backing_root/${backing_part:+${backing_part}/}/bcache/

      [ -d "$backing_sysfs_bcache" ] || { echo "Error: $bdev is not a registered bcache device."; exit 1; }

      echo "Detaching cache from backing store '$bdev'..."
      echo 1 > $backing_sysfs_bcache/detach
      # I don't know for sure that "stop" will only complete once dirty data
      # has been written out.
      echo "Stopping backing store '$bdev'..."
      { echo 1 > $backing_sysfs_bcache/stop; } > "$DESTROY_LOG" 2>&1
    done

    if [ -n "$CACHE_DEV" ]; then
      cache_part=$(basename $CACHE_DEV)
      cache_root=$(basename $CACHE_DEV |sed -e 's/[0-9]//g')
      cache_sysfs_bcache=/sys/block/$cache_root/$cache_part/bcache/

      if [ ! -d "$cache_sysfs_bcache" ]; then 
        echo "Error: $CACHE_DEV is not a registered bcache device."
      else
	echo "Stopping cache device..."
	{ echo 1 > /sys/block/$cache_root/$cache_part/bcache/set/stop; } > "$DESTROY_LOG" 2>&1
      fi
    fi
    echo "done."
  ;;

  *)
    echo "Error: invalid action '$action'"
    echo
    echo "Usage: bsetup create <backing device> [ <cache device> ]"
    echo "       bsetup destroy { <bcache device> | <backing device> }"
    echo
    echo "On create, a cache device will be created if supplied. Otherwise"
    echo "it is assumed that an existing cache set should be used."
    echo
    echo "On destroy, the backing device and cache set will be removed if"
    echo "a bcache device is given. Otherwise, only the backing device is"
    echo "removed"
   
    exit 1
  ;;
esac
