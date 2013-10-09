From: Greg KH <greg@kroah.com>
Subject: Re: bcache oops in bch_insert_data with the latest stables fixes
 (3.10.15)
Date: Wed, 9 Oct 2013 14:25:52 -0700
Message-ID: <20131009212552.GA24271@kroah.com>
References: <52513DBD.80005@excellency.fr>
 <525186E3.4000905@gmail.com>
 <525483A4.5020607@gmail.com>
 <20131008223221.GD7202@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131008223221.GD7202@kmo>
Sender: stable-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>, linux stable <stable@vger.kernel.org>, cbay@excellency.fr, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, Oct 08, 2013 at 03:32:21PM -0700, Kent Overstreet wrote:
> On Wed, Oct 09, 2013 at 12:13:56AM +0200, Gabriel de Perthuis wrote:
> > Le 06/10/2013 17:50, Gabriel de Perthuis a =E9crit :
> > > Le 06/10/2013 12:38, Cyril B. a =E9crit :
> > >> Hello,
> > >>
> > >> I get the following oops immediately after booting on 3.10.15.
> > >> Everything works fine in 3.10.10. Both the backing and cache dev=
ices are
> > >> on top of mdadm.
> > >=20
> > > Reverting c0f04d88e46d14de51f4baebb6efafb7d59e9f96 fixes it; it w=
as one
> > > of the few commits that's in 3.12 and -stable but not in
> > > bcache-for-3.11.  That commit causes bch_insert_data to be called=
 with
> > > an unset op.cache_bio.
> >=20
> > Pinging stable,
> > http://git.kernel.org/linus/c0f04d88e46d14de51f4baebb6efafb7d59e9f9=
6
> > should be reverted.  It was in 3.11.4 and 3.10.15 (and 3.12-rc3).
> > It breaks bcache's writeback mode by calling bch_writeback_data wit=
hout
> > setting cache_bio (it's more visible here[1]).  There's a bit of
> > indirection through closure calls, but it could never work.
>=20
> Greg - I screwed up on that patch (and I'm still scratching my head a=
s
> to how testing missed it) - it's a two line fix I'll be mailing off t=
o
> Linus shortly, or if you don't want to wait for that reverting it mig=
ht
> be better (though there was a data corruption bug that users reported
> that fixed, so I'd be hesitent there):
>=20
> Here's the fix I just mailed out, just waiting on a bit of outside
> testing to mail it to Linus:
>=20
> http://permalink.gmane.org/gmane.linux.kernel.bcache.devel/2113

I'll wait for the new patch to get into Linus's tree, so as to keep
things synced up.  Let me know what the git commit it of the patch is
when hit hits his tree and I'll add it to the next stable queue.

thanks,

greg k-h
