From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools and bcache support in other linux packages
Date: Mon, 21 Oct 2013 14:34:35 +0200
Message-ID: <CE8AE869.BD62%rolf@rolffokkens.nl>
References: <20131020185937.GA18759@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131020185937.GA18759-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>, Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Development discussions related to Fedora <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org



Op 10/20/13 8:59 PM schreef Piergiorgio Sartor
<piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>:

>Does the tools converts the complete RAID-10, including
>the LVM volumes to bcache?

I will look into the blocks tool for F21, but for now I leave answering
the question to Gabriel.
>
>Some times ago I asked, in my setup, what would be the
>right approach to bcache, between "caching" the RAID
>or caching each LVM volume and the answer was that the
>usual way is to cache the RAID.
>
>Any changes on this statement?

I can imagine that one may wish to (b)cache one specific LV and not the
other(s) in the same VG in which case bcache is to be used on top of the
specific LV. I think in general however it's best to use LVM on top of
bcache because it's closer to the (slow) storage you want to accelerate.
So I guess it depends on your requirements.

I'm not sure if there are specific technical arguments in favour of one or
the other. But I can say I've seen both work during testing.

Rolf
