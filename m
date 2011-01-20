From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: support for physical ramdisk
Date: Wed, 19 Jan 2011 16:22:06 -0800
Message-ID: <AANLkTik30_V_bWGsvoUQw-5-W7URK1tSTDSfcTa8LayX@mail.gmail.com>
References: <4D377D66.5020609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D377D66.5020609-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

It'd function, but performance would be worse than just using the
pagecache, bcache does a whole lot of extra work to get around the
limitations of SSDs and the pagecache is blazing fast. Why would you
want to do that?

On Wed, Jan 19, 2011 at 4:10 PM, Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I stumbled upon bcache today and was wondering, how would this work w=
ith a
> physical ramdisk instead of a SSD?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache"=
 in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
