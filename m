From: Leslie Basmid <leslie.basmid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Very poor performances with the bcache-for-upstream branch
Date: Thu, 2 May 2013 18:13:28 +0200
Message-ID: <CA+XuAnLbACwvUm7x0ur-cYFNOk2i4qw7QprhZ8miUaHe0QC-LA@mail.gmail.com>
References: <CA+XuAnJO4BCE0yj0i_CZ_iQvDj56FHwFZH302XrisD45P5R3Tw@mail.gmail.com>
	<klsuru$l60$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <klsuru$l60$2@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hello Gabriel,

thank you for your interest in my problem !

I'm quite sure that my cache is assembled: omitting to register my two
devices in linuxrc leads to my lvm not being found (which is quite
logical I think):

echo /dev/sda4 > /sys/fs/bcache/register
echo /dev/sdb > /sys/fs/bcache/register

Anyway, here is the result of the command you requested:

$ ls -d /sys/fs/bcache/*/bdev*
/sys/fs/bcache/< cache set >/bdev0

I'd be glad to provide more info as needed,
Thanks in advance,

Leslie.

On Thu, May 2, 2013 at 7:50 AM, Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> 2. I have setup an LVM above bcache, and /dev/sda4 is the only cache
>> partition. The whole thing was setup with:
>>
>> make-bcache -B /dev/sda4 -C /dev/sdb
>>
>> the LVM is "inside" /dev/sda4
>> 3. I am using fio as a benchmark, have setup writeback
>> # cat /sys/block/bcache0/bcache/writeback_running
>> 1
>> and I think I have followed every hints I could found about performance tuning.
>> Yet, when running the ssd fio test suite on a file on partition that
>> is not "cached", I am obtaining the following figures:
>> seq-read: iops=29156
>> rand-read: iops=291
>> seq-write: iops=22355
>> rand-write: iops=260
>>
>> Running it on a cached file system I'm obtaining:
>> seq-read: iops=22196
>> rand-read: iops=330
>> seq-write: iops=15864
>> rand-write: iops=387
>>
>> What am I missing ?
>
> Outside of the make-bcache, none of the commands you give in the thread
> prove that the cache is assembled (it's actually possible to have
> writeback_running = 1 with a detached bdev, though that's a bug in my
> opinion).  What does `ls -d /sys/fs/bcache/*/bdev*` show?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
