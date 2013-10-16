From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: good bcache use case?
Date: Wed, 16 Oct 2013 12:29:30 -0700
Message-ID: <04b801cecaa6$0ad387e0$207a97a0$@acm.org>
References: <1005c01cec92f$b61b2040$225160c0$@acm.org> <1381849203.67736.YahooMailNeo@web181503.mail.ne1.yahoo.com> <038e01cec9da$8a19e750$9e4db5f0$@acm.org> <525DAFA3.4060709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <525DAFA3.4060709-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Gabriel de Perthuis' <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: Gabriel de Perthuis [mailto:g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, October 15, 2013 2:12 PM
>
> 3.10.x and 3.11.y stable kernels have been getting bcache backports
[...]
> that introduced the crash was fixing a more serious bug.  Stopping here
> because the mailing list is starting to feel like Groundhog day.

Sorry, I did do some specific searching on the mailing list and a quick
review of recent traffic, don't mean to make you guys rehash stuff.

3.10.16 was just released this week, does that contain backports for all
known serious issues and would be considered suitable for production
deployment?

> but since LVM can do raid and a single cache can cache multiple devices,

I've seen references to raid using lvm (as opposed to lvm over md raid), but
it's never really been clear to me whether that is considered an alternative
to md raid, or a replacement, or whether it's better to do raid within lvm
rather than layering lvm on top of md raid. At this point, I'm considerably
more familiar with md raid so I've just been sticking with that.

Thanks much.
