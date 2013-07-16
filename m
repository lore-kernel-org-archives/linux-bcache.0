From: Campbell Steven <casteven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fwd: Bug#715019: linux-image-3.10-rc7-amd64: Bcache (with cache
 on LVM?) stops system from shutting down
Date: Wed, 17 Jul 2013 10:17:02 +1200
Message-ID: <CAPerZE-Vt2_9ohTeq3r6hjveH9mBM_bhJhjAzrAhqQpaUi_ZTA@mail.gmail.com>
References: <CAPBO7Tb9EvxnyeV-xWjsx3Z2NRbDRbRurVmfkU9rsOnUwSBP3A@mail.gmail.com>
	<CAPBO7TYo16QrYUF7-ZRaOZUJi_eXgGqxsv8oh_WgpjFhK3xfuw@mail.gmail.com>
	<20130716214205.GB2724@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130716214205.GB2724@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

>>
>> Hello,
>>
>> I have added new info to this bug. Forward it to this list:
>>
>> To: 715019-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
>> Subject: Bug#715019: linux-image-3.10-rc7-amd64: Bcache (with cache on LVM?)
>> stops system from shutting down
>> From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Date: Sun, 14 Jul 2013 00:55:00 +0200
>> Message-id:
>> <CAPBO7TbcPWAq2rePLsxLapb8y75gNWmUe-RB6ONcR9cNd=cEag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
>> Reply-to: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 715019-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
>>
>> ________________________________
>> Hello,
>>
>> I would like to comment that the same behaviour is happening to my system.
>>
>>
>> Root filesystem is ext3 on /dev/bcache0, which works with /dev/sda3 as the
>> backing partition and /dev/sdb as the cache disk (it is an msata version).
>> (System was on LVM before, but changed it to ext3 to keep it easier for the
>> bcache).
>>
>> bcache is not shutting down well, and the system cannot shutdown,reboot,
>> suspend, hibernate.
>> When shutting down, messages are like:
>>
>> ...
>> mei_me 000:00:16:0:stop
>> exception Emask 0x0 SACT 0x3 SErr 0x0 action 0x6 frozen
>> failed command: WRITE FPDMA QUEUED
>> ata3.00: cmd 61/08:00:60:6d:0e/00:00:00:00:00/40 tag 0 ncq 4096 out
>> res 40:00:f4:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
>> ata 3.00: status: {DRDY}
>> ata3: COMRESET failed (errno=-16)
>> end_request: I/O error, dev sdb, sector xxxxxx
>> bcache: bch_count_io_error() sdb:
>> IO error on writing btree, recovering
>> I/O error, dev sdb, sector xxxxxx
>> ...
>>
>> And keeps pausing and showing messages...
>>
>> I wish that this info helps to find a solution...
>
> Hrm, wonder what's causing the IO errors...
>
> I did fix the reboot notifier the other day, can you try either my
> bcache-for-3.10 or bcache-for-3.11 branches? That should fix shutdown
> and reboot.
>
> Suspend and hibernate should be fixed in the for-3.11 branch, but I
> think I'll need to backport a freezer fix for it to work in 3.10...
> --

I've been following this and testing all changes related to it and
still see the same as I reported earlier (and same errors). The
screenshots off the console show the same errors on the latest from
the bcache-for-3.11 branch when shutting down.

https://www.btg.co.nz/Public/2.jpg
https://www.btg.co.nz/Public/3.jpg
https://www.btg.co.nz/Public/4.jpg
https://www.btg.co.nz/Public/6.jpg

http://thread.gmane.org/gmane.linux.kernel.bcache.devel/1715

Kent, contact me off list if it is of any help for me to give you
access to a box where this is an issue. Or if there is anything else I
should try configuration wise.

Thanks

Campbell
