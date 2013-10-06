From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache oops in bch_insert_data with the latest stables fixes
 (3.10.15)
Date: Sun, 06 Oct 2013 17:50:59 +0200
Message-ID: <525186E3.4000905@gmail.com>
References: <52513DBD.80005@excellency.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52513DBD.80005-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Le 06/10/2013 12:38, Cyril B. a =E9crit :
> Hello,
>=20
> I get the following oops immediately after booting on 3.10.15.
> Everything works fine in 3.10.10. Both the backing and cache devices =
are
> on top of mdadm.

Reverting c0f04d88e46d14de51f4baebb6efafb7d59e9f96 fixes it; it was one
of the few commits that's in 3.12 and -stable but not in
bcache-for-3.11.  That commit causes bch_insert_data to be called with
an unset op.cache_bio.
