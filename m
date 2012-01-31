From: infernix <infernix-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org>
Subject: Re: bcache with iscsi, mpath and lvm
Date: Tue, 31 Jan 2012 17:04:26 +0100
Message-ID: <4F28110A.8070309@infernix.net>
References: <4F280A82.3070802@infernix.net> <CAOzFzEjE+h5wgY0JhZ6L5mJKtpLYyCSuErFWCd=E0UWNTTsQbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEjE+h5wgY0JhZ6L5mJKtpLYyCSuErFWCd=E0UWNTTsQbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Op 31-1-2012 16:50, Joseph Glanville schreef:
>> I've got the following stack, bottom to top:
>> - iscsi sans with multiple NICs
>> - servers with multiple NICs
>> - open-iscsi cross-connecting to the san over those multiple nics
>> - multipath to aggregate and load-balance IO over said paths
>> - LVM on top of multiple mpathX devices
>> - qemu-kvm running with disks connecting to logical volumes in said LVM

> If you are bottlenecking purely on random I/O then the easiest and
> most logical place for bcache is infront of your iSCSI backing store
> on your SAN.

Agreed. But since the SAN is proprietary, there's zero chance of 
implementing bcache on the SAN :)

> If however you are bottlenecked on the iSCSI interconnect you could
> feasibly place bcache ontop of the multipath devices (they are just
> standard dm targets) right below the VMs.
> This adds the highest possible amount of performance to the VMs at the
> cost of increased maintaince, complexity of multiple caches and
> ofcourse cost.

Yes. So that is why I think the tradeoff of putting bcache on the mpath 
devices is the best. There's no shared storage use between servers; each 
just uses its own LVs. As long as I'm using writethrough, this is safe. 
Doing writeback is simply impossible with multiple caches like this.

Setting up bcache for each and every logical volume is not really going 
to work because they are quite dynamic.

>> Is there any other way of activating bcache besides passing it an UUID? And
>> can it even work on top of a dm-multipath device?
>
> It works on LVM so it should work fine on multipath targets too.

Except that I can't get an UUID from the LVM PVs:

blkid /dev/mpath/mpath2 -s UUID -o value

Returns nothing. So I'm a little confused as to how to register the 
device for caching.
