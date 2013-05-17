From: =?ISO-8859-1?Q?Robert_Fr=E5nlund?= <robert.franlund-Hou3YEnI4S0Iwnw1HX0dmQ@public.gmane.org>
Subject: Re: Poor performance with bcache write-back mode
Date: Fri, 17 May 2013 08:28:57 +0200
Message-ID: <CA+gjuN7ptnXbmO2CbCKL2RgaxW86Mv_8vZqWRjB6Zv+ffWFHxA@mail.gmail.com>
References: <1368741106.62060.YahooMailNeo@web162401.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368741106.62060.YahooMailNeo-QseONlJJzSFal3a5i+KC+JEhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mailinglist_bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

Have you aligned your partitions on the SSD to at-least 4 KiB
block-size, even better with 1 MiB?

Best regards,
Robert

2013/5/16 Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>:
> Hi all,
>
> I have installed Linux kernel 3.9.2 in my Fedora 18.  When I ran FIO in bcache write-through mode, the performance was good, but running a similar test in bcache write-back mode, I got very poor performance.
> Did I miss any options when setting the write-back mode?
>
> Environment
> ===========
> 500G backing store at /dev/sdb1
> 150G SSD at /dev/sdc1
>
> Write-through mode
> ==================
> make-bcache -B /dev/sdb1 -C /dev/sdc1
> echo /dev/sdb1 > /sys/fs/bcache/register
> echo /dev/sdc1 > /sys/fs/bcache/register
> mkfs.ext4 /dev/bcache0
> mount /dev/bcache0 /mnt/bcache
>
>
> Running FIO with random, 100% read, iosize=4096, queue depth=16
> the result is approx. 65k IOPS
>
>
> Write-backe mode (setup is almost the same as write-through except the extra step at the end "echo writeback ...")
> ================
> make-bcache -B /dev/sdb1 -C /dev/sdc1
> echo /dev/sdb1 > /sys/fs/bcache/register
> echo /dev/sdc1 > /sys/fs/bcache/register
> mkfs.ext4 /dev/bcache0
> mount /dev/bcache0 /mnt/bcache
> echo writeback > /sys/block/bcache0/bcache/cache_mode
>
> Running FIO with random, 100% read, iosize=4096, queue depth=16
> the result is approx. 12k IOPS
>
> Running FIO with random, 80% read 20% write, iosize=4096, queue depth=16
> the result is approx. 2k IOPS
>
> Thanks,
> Patrick
