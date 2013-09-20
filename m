From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache & btrfs: "Btrfs detected SSD devices, enabling SSD mode"
Date: Fri, 20 Sep 2013 21:25:29 +0200
Message-ID: <523CA129.1000508@rolffokkens.nl>
References: <523C71C4.9030606@rolffokkens.nl> <523C76F4.3070809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523C76F4.3070809-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 09/20/2013 06:25 PM, Gabriel de Perthuis wrote:
> SSD [=85] optimizations (e.g. avoiding unnecessary seek optimizations=
,
> sending writes in clusters, even if they are from unrelated files. Th=
is
> results in larger write operations and faster write throughput)
>
> The optimisations should be beneficial iff bcache is used in writebac=
k
> mode.  ssd_spread and discard are enabled separately; I'm not sure wh=
at
> ssd_spread (from the wiki: more strict about finding a large unused
> region of the disk for new allocations) would do for bcache.
 From observing iostat I have the impression that bcache sometimes=20
bypasses the cache, probably related to sequential_cutoff. Seems like=20
btrfs tries to cluster writes (because an SSD is detected) and next=20
bcache bypasses the SSD (because the writes are clustered). Doesn't see=
m=20
the right kind of cooperation :-)

(Assuming of course that clustered writes are based on sequential write=
s)
