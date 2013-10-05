From: Mike <ipso-b1rgQ1Vu1oQlc7lGOYXu6Q@public.gmane.org>
Subject: bcache-register invoked oom-killer
Date: Sat, 05 Oct 2013 12:36:24 -0700
Message-ID: <52506A38.608@snappymail.ca>
Reply-To: ipso-b1rgQ1Vu1oQlc7lGOYXu6Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I seem to be having some major difficulty getting a stable bcache system 
setup. I initially started with Kernel v3.11 and quickly ran into data 
corruption problems (couldn't even install Ubuntu-server in a VM on the 
bcache device), so I upgraded to v3.12rc3 which contained the recent 
data corruption bug fix and things seemed to work better.

Cut to the next day after a power failure and all hell has broken loose, 
when I booted the machine up fsck fixed a bunch of corruption errors on 
the bcache device, but there are constantly new ones popping up after 
light usage, such as:

Oct  5 10:56:24 vm3 kernel: [   88.778956] EXT4-fs error (device dm-0): 
ext4_mb_generate_buddy:756: group 10766, 32448 clusters in bitmap, 32768 
in gd; block bitmap corrupt.
Oct  5 10:56:24 vm3 kernel: [   88.778969] Aborting journal on device 
dm-0-8.
Oct  5 10:56:24 vm3 kernel: [   88.780641] EXT4-fs (dm-0): Remounting 
filesystem read-only
Oct  5 10:56:24 vm3 kernel: [   88.780825] EXT4-fs error (device dm-0): 
ext4_mb_generate_buddy:756: group 10767, 32448 clusters in bitmap, 32768 
in gd; block bitmap corrupt.
<snip a few hundred lines>
Oct  5 10:56:24 vm3 kernel: [   88.831774] EXT4-fs error (device dm-0): 
ext4_mb_generate_buddy:756: group 11001, 8112 clusters in bitmap, 2136 
in gd; block bitmap corrupt.

I rebooted into single mode to run fsck a few more times, but upon a 
normal boot bcache invoked the oom-killer. Now everytime I reboot I get 
a new /dev/bcache? device, I'm up to /dev/bcache3 at this point...

Here is some system information:

- Linux vm3 3.12.0-031200rc3-generic #201309291835 SMP Sun Sep 29 
22:37:02 UTC 2013 x86_64
- Memory: 64gb ECC
- The filesystem was formatted with ext4 in largefile4 mode, on top of 
LVM, which was on top of BCACHE, which was on top of software RAID1.

# blkid
/dev/bcache3: UUID="TllbXZ-h29v-egAm-xdK9-tWK5-UMPm-aePAUc" 
TYPE="LVM2_member"
/dev/sdb1: UUID="F7A0-9938" TYPE="vfat"
/dev/sdc3: UUID="73bfb773-d58d-d44b-c29f-e11574e720a3" 
UUID_SUB="1a89bbfc-7a68-a5d9-00d2-dbdeeaf73bdc" LABEL="vm3:1" 
TYPE="linux_raid_member"
/dev/sdc2: UUID="0b36e731-d8f2-1ed2-8661-33e118045468" 
UUID_SUB="f0d40ed7-17ee-a6d5-a686-3acb205b0609" LABEL="vm3:0" 
TYPE="linux_raid_member"
/dev/sdc1: UUID="58aebac9-d829-4c80-8428-15a234da9a88" TYPE="ext2"
/dev/dm-0: UUID="9741d01d-59b2-459a-9df8-a243830e56d9" TYPE="ext4"
/dev/sda1: UUID="7821e9da-144e-4bf6-8700-e9b4a794240a" TYPE="swap"
/dev/sdb2: UUID="0b36e731-d8f2-1ed2-8661-33e118045468" 
UUID_SUB="2aadfa93-df66-ef2d-8479-80ea2eb823d2" LABEL="vm3:0" 
TYPE="linux_raid_member"
/dev/sdb3: UUID="73bfb773-d58d-d44b-c29f-e11574e720a3" 
UUID_SUB="6e0ca23c-04fa-6549-1fc2-fa251459fe31" LABEL="vm3:1" 
TYPE="linux_raid_member"
/dev/md0: UUID="8577302d-1f37-40a6-afcd-385beb26059f" TYPE="ext4"
*/dev/sda2 wasn't in the list, but its the bcache cache device.
*/dev/md1 is the bcache backing device.
*/dev/dm-0 is on top of bcache.

The dmesg trace output here:
http://pastebin.com/HidrFAmS

Does this look like a bug or hardware issues?

Thanks.

-- 
Mike
