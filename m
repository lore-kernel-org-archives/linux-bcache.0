From: Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: Poor performance with bcache write-back mode
Date: Fri, 17 May 2013 13:13:04 -0700 (PDT)
Message-ID: <1368821584.52750.YahooMailNeo@web162405.mail.bf1.yahoo.com>
References: <1368741106.62060.YahooMailNeo@web162401.mail.bf1.yahoo.com> <CA+gjuN7E2B+71BiCexm7HjDGzJMBuCdbGxhvD8YHU6-u6TyKkg@mail.gmail.com>
Reply-To: Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+gjuN7E2B+71BiCexm7HjDGzJMBuCdbGxhvD8YHU6-u6TyKkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?Robert_Fr=E5nlund?= <robert.franlund-Hou3YEnI4S0Iwnw1HX0dmQ@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Robert,

I have checked that the cache partition (/dev/sdc1) starts at 2048, it =
should be properly aligned.
Similarly for the backing store partition (/dev/sdb1), it starts at 204=
8 at well.
=A0
Thanks,
Patrick
>________________________________
> From: Robert Fr=E5nlund <robert.franlund-Hou3YEnI4S0Iwnw1HX0dmQ@public.gmane.org>
>To: Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>=20
>Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>=20
>Sent: Friday, May 17, 2013 2:22 AM
>Subject: Re: Poor performance with bcache write-back mode
>=20
>
>
>Hi,
>
>
>Have you aligned your partitions on the SSD to at-least 4 KiB block-si=
ze, even better with 1 MiB?
>
>
>Best regards,
>Robert
>
>
>
>
>
>
>
>2013/5/16 Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
>
>Hi all,
>>
>>I have installed Linux kernel 3.9.2 in my Fedora 18. =A0When I ran FI=
O in bcache write-through mode, the performance was good, but running a=
 similar test in bcache write-back mode, I got very poor performance.
>>Did I miss any options when setting the write-back mode?
>>
>>Environment
>>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>500G backing store at /dev/sdb1
>>150G SSD at /dev/sdc1
>>
>>Write-through mode
>>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>make-bcache -B /dev/sdb1 -C /dev/sdc1
>>echo /dev/sdb1 > /sys/fs/bcache/register
>>echo /dev/sdc1 > /sys/fs/bcache/register
>>mkfs.ext4 /dev/bcache0
>>mount /dev/bcache0 /mnt/bcache
>>
>>
>>Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
>>the result is approx. 65k IOPS
>>
>>
>>Write-backe mode (setup is almost the same as write-through except th=
e extra step at the end "echo writeback ...")
>>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>make-bcache -B /dev/sdb1 -C /dev/sdc1
>>echo /dev/sdb1 > /sys/fs/bcache/register
>>echo /dev/sdc1 > /sys/fs/bcache/register
>>mkfs.ext4 /dev/bcache0
>>mount /dev/bcache0 /mnt/bcache
>>echo writeback > /sys/block/bcache0/bcache/cache_mode
>>
>>Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
>>the result is approx. 12k IOPS
>>
>>Running FIO with random, 80% read 20% write, iosize=3D4096, queue dep=
th=3D16
>>the result is approx. 2k IOPS
>>
>>Thanks,
>>Patrick=A0
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
>>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>=A0
