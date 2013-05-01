From: Leslie Basmid <leslie.basmid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Very poor performances with the bcache-for-upstream branch
Date: Wed, 1 May 2013 15:30:12 +0200
Message-ID: <CA+XuAnK4nNOG_tSuuteDThbj5L+5xmDsxQLfrHj314z1fr+bUA@mail.gmail.com>
References: <CA+XuAnJO4BCE0yj0i_CZ_iQvDj56FHwFZH302XrisD45P5R3Tw@mail.gmail.com>
	<CAC7rs0t4uKx37i7pxMoMQgVeUT6spDeridfdC+R6mqLbf1dwug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0t4uKx37i7pxMoMQgVeUT6spDeridfdC+R6mqLbf1dwug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

this is exactly the documentation I had followed to try to track the
bad performance issues I was experiencing.
Redoing a whole run, trying to force everything into writeback mode,
by disabling both the sequential bypass
echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
and the congested thresholds
echo 0 > /sys/fs/bcache/<set>/congested_read_threshold_us,
echo 0 > /sys/fs/bcache/<set>/congested_write_threshold_us


I am obtaining the following figures, on a cached fs:
seq-read: iops=12188
rand-read: iops=7392
seq-write: iops=430
rand-write: iops=454

I must be missing something, and I would really appreciate any help on
the matter.

Thanks in advance,
Leslie.

On Mon, Apr 29, 2013 at 7:52 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> There's documentation for exactly this stuff, linked off the main page
> of the wiki:
>
> http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev#n126
>
> On Mon, Apr 29, 2013 at 8:43 AM, Leslie Basmid <leslie.basmid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi all,
>>
>> I have chosen to install bcache using the bcache-for-upstream branch
>> (recompiled this morning for the latest patches). Even though
>> everything is running smoothly, I am surprised by the very poor
>> performance I'm obtaining from my setup.
>>
>> 1. Everything is setup on my laptop which has a 500GB HD (sda) and a
>> 16 GB SSD (sdb).
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
>> The benchmark parameters are:
>> bs=4k
>> ioengine=libaio
>> iodepth=64
>> size=1g
>> direct=1
>>
>> Thanks in advance for your answers,
>> Leslie.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
