From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Data corruption with bcache in 3.11
Date: Fri, 20 Sep 2013 00:44:02 -0700
Message-ID: <CALJ65zkj2U-Kr_EBx7RJETqW2jQmWxsr0QmZspHU3H+jDts3tQ@mail.gmail.com>
References: <20130920023501.GJ17891@kmo-pixel>
	<523BF3EB.7050709@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523BF3EB.7050709-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

If you weren't seeing it before, don't worry about it. Normal setups
with the usual 4k block size won't ever see this.

On Fri, Sep 20, 2013 at 12:06 AM, Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org> wrote:
> I'm using bcache on my system for about a week now, and all seems rock solid
> to me. I'm even running my root FS on bcache, which means my system might no
> longer boot when something goes wrong. Based on reported issues I also did
> some stress tests to see if anything breaks, e.g. by starting cp's and
> rsync's and see what happens. I can only tell they don't involve much
> caching, but there's no data corruption.
>
> If I can help by trying to reproduce issues, let me know. I tried, but
> wasn't successful in reproducing issues. So provide any instructions on what
> to reproduce and I'll try to do that. Of course the easiest way to reproduce
> for me would be to do it in a VM, but I'm also OK with using my physical
> "test-configuration".
>
> Rolf
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
