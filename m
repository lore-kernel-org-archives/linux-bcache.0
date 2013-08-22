From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Flushing dirty data after bcache detach
Date: Wed, 21 Aug 2013 23:07:01 -0700
Message-ID: <20130822060701.GC14935@kmo-pixel>
References: <423285490.335846.1377074174264.JavaMail.root@thomas-krenn.com>
 <1057573722.337424.1377074937216.JavaMail.root@thomas-krenn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1057573722.337424.1377074937216.JavaMail.root-qD/LZSXtZz5FYGZjsVlUvw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger-qD/LZSXtZz5FYGZjsVlUvw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Aug 21, 2013 at 10:48:57AM +0200, Georg Sch=C3=B6nberger wrote:
> Hi bcache team,
>=20
> we are currently developing performance test scripts with Fio for bca=
che.
> At the end of a test we want to detach and destroy the cache. Therefo=
re we did:
>     echo 1 > /sys/block/$dev/bcache/detach
>     echo 1 > /sys/block/$dev/bcache/stop
>=20
>     echo 1 > /sys/fs/bcache/*/stop
>     echo 1 > /sys/fs/bcache/*/unregister
>=20
> With a simple randwrite test with we had about 2GB dirty data in the =
cache. After detaching the dirty data flush rate was about 900KB/s from=
 SSD to HDD.
> Is there a way to accelerate flushing of dirty data?
> What is the correct way to detach/destroy a writeback caching device?

The stop is unnecessary for the cache set (that'll shut down the cache
set without detaching anything or flushing dirty data).

900KB/sec sounds like a bug though - I'll try and take a look at it
tomorrow.
