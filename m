From: infernix <infernix-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org>
Subject: bcache with iscsi, mpath and lvm
Date: Tue, 31 Jan 2012 16:36:34 +0100
Message-ID: <4F280A82.3070802@infernix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I've got the following stack, bottom to top:

- iscsi sans with multiple NICs
- servers with multiple NICs
- open-iscsi cross-connecting to the san over those multiple nics
- multipath to aggregate and load-balance IO over said paths
- LVM on top of multiple mpathX devices
- qemu-kvm running with disks connecting to logical volumes in said LVM

I am wondering if bcache can fit in, and if so, where?

Ideally I would say it sits between multipath and LVM, e.g. it is active 
for the /dev/mapper/mpathX devices. But that doesn't work because there 
isn't really a filesystem on it and so it doesn't get assigned an UUID. 
Even if it did, that UUID would be the same for all sdX devices in the 
multipath device.

Is there any other way of activating bcache besides passing it an UUID? 
And can it even work on top of a dm-multipath device?

Thanks!
