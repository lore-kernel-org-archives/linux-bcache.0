From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache oops in bch_insert_data with the latest stables fixes
 (3.10.15)
Date: Tue, 8 Oct 2013 15:32:21 -0700
Message-ID: <20131008223221.GD7202@kmo>
References: <52513DBD.80005@excellency.fr>
 <525186E3.4000905@gmail.com>
 <525483A4.5020607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <525483A4.5020607-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Oct 09, 2013 at 12:13:56AM +0200, Gabriel de Perthuis wrote:
> Le 06/10/2013 17:50, Gabriel de Perthuis a =C3=A9crit :
> > Le 06/10/2013 12:38, Cyril B. a =C3=A9crit :
> >> Hello,
> >>
> >> I get the following oops immediately after booting on 3.10.15.
> >> Everything works fine in 3.10.10. Both the backing and cache devic=
es are
> >> on top of mdadm.
> >=20
> > Reverting c0f04d88e46d14de51f4baebb6efafb7d59e9f96 fixes it; it was=
 one
> > of the few commits that's in 3.12 and -stable but not in
> > bcache-for-3.11.  That commit causes bch_insert_data to be called w=
ith
> > an unset op.cache_bio.
>=20
> Pinging stable,
> http://git.kernel.org/linus/c0f04d88e46d14de51f4baebb6efafb7d59e9f96
> should be reverted.  It was in 3.11.4 and 3.10.15 (and 3.12-rc3).
> It breaks bcache's writeback mode by calling bch_writeback_data witho=
ut
> setting cache_bio (it's more visible here[1]).  There's a bit of
> indirection through closure calls, but it could never work.

Greg - I screwed up on that patch (and I'm still scratching my head as
to how testing missed it) - it's a two line fix I'll be mailing off to
Linus shortly, or if you don't want to wait for that reverting it might
be better (though there was a data corruption bug that users reported
that fixed, so I'd be hesitent there):

Here's the fix I just mailed out, just waiting on a bit of outside
testing to mail it to Linus:

http://permalink.gmane.org/gmane.linux.kernel.bcache.devel/2113
