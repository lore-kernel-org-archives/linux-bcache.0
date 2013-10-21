From: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Subject: Re: bcache-tools and bcache support in other linux packages
Date: Mon, 21 Oct 2013 18:47:57 +0200
Message-ID: <20131021164756.GA8027@lazy.lzy>
References: <20131020185937.GA18759@lazy.lzy>
 <CE8AE869.BD62%rolf@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CE8AE869.BD62%rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>, Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Development discussions related to Fedora <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Oct 21, 2013 at 02:34:35PM +0200, Rolf Fokkens wrote:
[...]
> I can imagine that one may wish to (b)cache one specific LV and not the
> other(s) in the same VG in which case bcache is to be used on top of the
> specific LV. I think in general however it's best to use LVM on top of
> bcache because it's closer to the (slow) storage you want to accelerate.

Interesting, then logic would suggest to (b)cache
the components of the RAID.
Of, even better, to (b)cache /dev/sd[ab] (in this
case) and cover, in this way, everything.

> So I guess it depends on your requirements.

It's a desktop PC, I notice that performances
mainly depend on the storage subystem, the rest
(CPU, memory, GPU) is fine for me.

> I'm not sure if there are specific technical arguments in favour of one or
> the other. But I can say I've seen both work during testing.

Thanks,

bye,

-- 

piergiorgio
