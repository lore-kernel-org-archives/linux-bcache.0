From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache & btrfs: "Btrfs detected SSD devices, enabling SSD mode"
Date: Fri, 20 Sep 2013 18:25:24 +0200
Message-ID: <523C76F4.3070809@gmail.com>
References: <523C71C4.9030606@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523C71C4.9030606-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> This may be known already, but I noticed the following message in sys=
log
> during boot:
>=20
> Btrfs detected SSD devices, enabling SSD mode
>=20
> Btrfs is right in a sense: there is a SSD involved, but there's a HDD=
 as
> well. I don't think it is an issue, but I have no idea how "btrfs' SS=
D
> optimizations"  will interact with bcache. Might be interesting.


=46rom https://btrfs.wiki.kernel.org/ :
> SSD [=85] optimizations (e.g. avoiding unnecessary seek optimizations=
,
sending writes in clusters, even if they are from unrelated files. This
results in larger write operations and faster write throughput)

The optimisations should be beneficial iff bcache is used in writeback
mode.  ssd_spread and discard are enabled separately; I'm not sure what
ssd_spread (from the wiki: more strict about finding a large unused
region of the disk for new allocations) would do for bcache.
