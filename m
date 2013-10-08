From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache oops in bch_insert_data with the latest stables fixes
 (3.10.15)
Date: Wed, 09 Oct 2013 00:48:29 +0200
Message-ID: <52548BBD.9060601@gmail.com>
References: <52513DBD.80005@excellency.fr> <525186E3.4000905@gmail.com> <525483A4.5020607@gmail.com> <1381271982.70536.YahooMailNeo@web181505.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381271982.70536.YahooMailNeo-XYahOdtEMNnuQS8rMknbopOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Le mer. 09 oct. 2013 00:39:42 CEST, matthew patton a =C3=A9crit :
> I'm confused as to what tree is actually safe to use. When these and
> like messages go out are all of the 3.10, 3.11, 3.12 etc trees
> updated to kill the bad code? There seems to be a lot of churn and as
> a user I'm not sure what code-base to grab that has the
> recent/obscure bugs fixed, and which are time-bombs.
>=20
> Do all of the 3.10.x Linux kernel sources work with the bcache
> 3.10-stable git branch? Does 3.10-stable have *ALL* of the recent bug
> fixes included? If not, why not? Same for 3.11 and friends.
>=20
> A little guidance please?

3.11.4 minus the patch I mentioned is fine in my experience; I've been
running it for a while along with other people (through the
bcache-for-3.11 branch).  I'm not sure what corruption that patch was
meant to prevent; I haven't encountered it as far as I know.
