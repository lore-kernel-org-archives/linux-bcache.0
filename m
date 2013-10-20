From: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Subject: Re: bcache-tools and bcache support in other linux packages
Date: Sun, 20 Oct 2013 20:59:37 +0200
Message-ID: <20131020185937.GA18759@lazy.lzy>
References: <CE86CB5C.BB96%rolf@rolffokkens.nl>
 <5261380B.2020007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5261380B.2020007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>, Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Development discussions related to Fedora <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

first of all thank to Rolf for the report.
It helps a lot to understand the current
status and what it needs to be done.
Thanks again!

On Fri, Oct 18, 2013 at 03:30:51PM +0200, Gabriel de Perthuis wrote:
> > - Because it's hard to change an existing partition to a 'bcached'
> > partition, it's not really tempting to test (there's a blocks utility
> > under development that may help, currently backup-restore is the only way)
> 
> blocks[1] has been doing bcache conversion since forever (last march,
> when the project was renamed from lvmify).

I've got a question about this.

I've two HDDs combined with "md" RAID-10 and, on top
of the RAID, LVM volumes (there is a separted RAID-1
for /boot, too).

Does the tools converts the complete RAID-10, including
the LVM volumes to bcache?

Some times ago I asked, in my setup, what would be the
right approach to bcache, between "caching" the RAID
or caching each LVM volume and the answer was that the
usual way is to cache the RAID.

Any changes on this statement?

Thanks,

bye,

pg

> Backup-restore hasn't been necessary since then, apart from unusual
> cases, like not having a /boot partition.
> 
> [1] https://github.com/g2p/blocks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
