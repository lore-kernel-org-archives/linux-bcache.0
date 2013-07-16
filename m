From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: label devices got removed after format
Date: Tue, 16 Jul 2013 22:16:44 +0000 (UTC)
Message-ID: <ks4goc$o2d$1@ger.gmane.org>
References: <51DE7E3A.5070709@profihost.ag>
	<20130712012806.GB17799@kmo-pixel> <krom21$tfo$2@ger.gmane.org>
	<51DFDE21.2040309@profihost.ag> <kroq08$tfo$3@ger.gmane.org>
	<20130716213756.GA2724@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, 16 Jul 2013 14:37:56 -0700, Kent Overstreet wrote:
> On Fri, Jul 12, 2013 at 11:40:56AM +0000, Gabriel de Perthuis wrote:
>> The Squeeze version of udev chokes on newlines in labels, to the point
>> that all the device's symlinks are removed; the uuid symlinks aren't
>> even involved in label uevents.
>> As a workaround, the latest commit in [1] strips endlines when setting
>> the label.
>> 
>> [1] https://github.com/g2p/linux/commits/v3.10%2Bbcache-for-3.11
> 
> Thanks, applied.

Thanks.

> Gabriel, would you mind sending me these patches with git format-patch
> or git send-email? I didn't see this until last night :)

Ah, sorry.  I iterated those pushes a bit, so I didn't mind you
not picking it up right away, but I'll try to switch to more visible
email next time.
