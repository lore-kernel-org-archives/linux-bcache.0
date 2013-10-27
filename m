From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Stopping a bcache device during shutdown
Date: Sun, 27 Oct 2013 16:35:37 +0100
Message-ID: <526D32C9.1070306@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

My system has the following block device stack: 
RootFS->LVM->bcache(bcache0)->RAID5(md1)->(sda2, sdb2, sdc2)

During shutdown on Fedora I noticed the following on console:

[  137.036846] dracut Warning: Unmounted /oldroot.
[  137.103139] dracut: Disassembling device-mapper devices
[  137.147160] dracut: Waiting for mdraid devices to be clean.
[  137.158556] dracut: Disassembling mdraid devices.
mdadm: Cannot get exclusive access to /dev/md1:Perhaps a running 
process, mounted filesystem or active volume group?
[  138.247044] bcache: bcache_reboot() Stopping all devices:
[  140.247073] bcache: bcache_reboot() Timeout waiting for devices to be 
closed
[  140.250295] Unregister pv shared memory for cpu 0
[  140.253139] kvm: exiting hardware virtualization

So apparently bcache is (b)locking /dev/md1 during shutdown. In an 
attempt to solve this, I added a "echo 1 > /sys/block/bcache0/bcache/stop":

[  137.036846] dracut Warning: Unmounted /oldroot.
[  137.076580] dracut: Stopping bcache devices
STOP /sys/block/bcache0/bcache/stop
[  137.103139] dracut: Disassembling device-mapper devices
[  137.147160] dracut: Waiting for mdraid devices to be clean.
[  137.158556] dracut: Disassembling mdraid devices.
mdadm: Cannot get exclusive access to /dev/md1:Perhaps a running 
process, mounted filesystem or active volume group?
mdadm: Cannot get exclusive access to /dev/md1:Perhaps a running 
process, mounted filesystem or active volume group?
mdadm: Cannot get exclusive access to /dev/md1:Perhaps a running 
process, mounted filesystem or active volume group?
[  137.200086] dracut: Stopping bcache cache sets
STOP /sys/fs/bcache/408c0554-9752-4126-916d-5c5fe32037d2/stop
Rebooting.
[  138.247044] bcache: bcache_reboot() Stopping all devices:
[  140.247073] bcache: bcache_reboot() Timeout waiting for devices to be 
closed
[  140.250295] Unregister pv shared memory for cpu 0

The 1st STOP... line is the result of a debugging "echo .." command:

for stop in /sys/block/bcache[0-9]*/bcache/stop; do
     [ -f "$stop" ] || continue
     echo 1 > "$stop"
     echo STOP $stop
done


The second STOP does the same for the cache set, but that's not the 
issue now.

 From both the documentation and testing I understand that the first 
STOP should mark the bcache0 device for stop as soon as it's no longer 
used, in this case by LVM. So when LVM (device mapper devices) is 
disassembled, bcache should actually stop the bcache0 device. But his 
apparently doesn't happen. I did a test with almost the same config, but 
without bcache between LVM and RAID5, in that case all works fine. So it 
looks like bcache is the cause.

So I may be misunderstanding the way "echo 1 > 
/sys/block/bcache0/bcache/stop" works. Are there any suggestions for my 
where to look further?

Thanks,

Rolf
