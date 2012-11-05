From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Kernel Oops (bCache hangs on registering 3rd device)
Date: Tue, 6 Nov 2012 00:49:20 +1100
Message-ID: <CAOzFzEjpdgNNnsXB4TQyJ2hAG91HZ19JEGJ+H9sQ9+akKiDW2g@mail.gmail.com>
References: <loom.20121104T035737-445@post.gmane.org>
	<loom.20121105T135531-268@post.gmane.org>
	<loom.20121105T140203-975@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20121105T140203-975-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 6 November 2012 00:15, James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org> wrote:
> James Sefton <james@...> writes:
>
>>
>> James Sefton <james@...> writes:
>>
>> >
>> > Hi,
>> >
>> > Seems I broke something.
>> > <.. pruned previous post ..>
>>
>> Yes, reproduced it after a clean boot.
>> It gets stuck creating the third cache device. (/dev/bcache2)
>>
>> Here is the latest info from kern.log, but it looks very similar to what I
>> posted before.
>>
>> http://pastebin.com/r8YRSNGR
>>
>> Any idea if I am doing something wrong or is this a bug?
>> I need to create up to 64 cache devices.  Possibly slightly over that on rare
>> occasions.  (The majority of servers will have 16-32)
>>
>> Many Thanks,
>>
>> James
>>
>>
>
>
> Aha,  I have more information.
>
> ls /dev/block -l
>
> <filtered results to relevant>
> lrwxrwxrwx 1 root root 10 Nov  5 12:51 252:0 -> ../bcache0
> lrwxrwxrwx 1 root root 10 Nov  5 12:51 252:1 -> ../bcache1
> lrwxrwxrwx 1 root root 12 Nov  5 12:51 252:2 -> ../bcache1p1
>
>
> Our script does things in the following order:
> 1. Registers bcache0 - OK
>  - links bcache0 in /dev/block/252:0
> 2. Registers bcache1 - OK
>  - links bcache1 in /dev/block/252:1
> 3. Partitions bcache1 - OK  (single partition at the moment)
>  - links bcache1p1 in /dev/block/252:2
> 4. Partitions bcache0 - Partition table writes okay, but bcache0p1 does not get
> created.
>  - presumably attempts to link /dev/block/252:1 or something, and fails.
> 5. Registers bcache2 - FAIL, prevents any further bcache devices being
> registered and prevents system shut-down.
>  - attempts to link bcache2 in /dev/block/252:2, which is already used for
> bcache1p1.
>
> Probably explains why this has not been seen before since we only just added
> support for partitions with the patch details you recently gave me.
>
> Any chance of a patch to fix the numbering?
> (I wish my C++ was up to scratch so that I could do it myself as it looks like
> it could be relatively simple!)
>
> Many Thanks,
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Though not a fix, a workaround could be to use LVM rather than partitions.

LVM ontop of bcache works quite nicely you just need to add the
following to /etc/lvm.conf

types = [ "bcache", 16 ]

Also check your filter line to ensure that /dev/bcacheX will be scanned as a PV.

Once you have done that you can create a volume group as usual:

vgcreate vg0 /dev/bcache0

And then any number of LVs:

lvcreate -n root -L50G vg0

In my opinion this is considerably better than partitions.

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
