From: =?UTF-8?B?UGF2ZWwgUGFsw6F0?= <pavel.palat-UDV0GzaorVTrBKCeMvbIDA@public.gmane.org>
Subject: Re: bcache writeback hang with 3.11.5 and 3.10.17
Date: Fri, 25 Oct 2013 11:00:19 +0200
Message-ID: <526A3323.4030608@devsoft.cz>
References: <5263DDC9.6050705@devsoft.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5263DDC9.6050705-UDV0GzaorVTrBKCeMvbIDA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 20.10.2013 15:42, Pavel Pal=C3=A1t wrote:
> Hello,
>
> I have experienced hangs with above kernel and bcache in writeback=20
> mode. Hangs are very easily archieved - just do:
>
> mkdir /data/tmp
> cp -xar / /data/tmp
>
> Cancel after 1-5 minutes, then do sync (sometimes don't needed) and i=
t=20
> hangs. Either the sync hangs and/or the cp (or rm /data/tmp).=20
> Behaviour is very consistent, it happens every time I enable writebac=
k=20
> and perform IO heavy operations.
>
> I have not experienced the issue so far with writethrough mode.
>
> Hardware is HP j000ec, attaching dmesg from hanged box with both=20
> 3.11.5 and 3.10.17 LTS kernel. Distribution is arch linux.
>
> dmesg outputs is available on=20
> http://www.devsoft.cz/upload/bcache_bugreport.tar.gz
>
> P.
Hello,

update: Tried with 3.12rc6 with same results. It also hangs with writeb=
ack.

http://www.devsoft.cz/upload/bcache_312.txt

Best regards,

Pavel Palat
