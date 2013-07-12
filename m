From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: label devices got removed after format
Date: Fri, 12 Jul 2013 10:33:37 +0000 (UTC)
Message-ID: <krom21$tfo$2@ger.gmane.org>
References: <51DE7E3A.5070709@profihost.ag>
	<20130712012806.GB17799@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, 11 Jul 2013 18:28:06 -0700, Kent Overstreet wrote:
> On Thu, Jul 11, 2013 at 11:43:22AM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi,
>> 
>> after doing mkfs.xfs -f /dev/bcache/by-label/mybcachelabel
>> 
>> /dev/bcache/by-label/mybcachelabel gots removed...
>> 
>> Only a reboot brings it back.
>> 
>> Stefan
> 
> Gabriel - I bet the uevent bcache is emitting is conflicting with the
> name of an existing label uevent; there'll be a symlink for the
> filesystem's label - for the same block device - so the mkfs could be
> causing another uevent to be emitted overwriting our label.

The uevent property is CACHED_LABEL, a name that shouldn't interfere
with the cached device's filesystem label.

> Or maybe the conflict is a bit more subtle - anyways, you added the
> label uevent code, think you might be able to figure it out?

I actually can't reproduce this; the link doesn't disappear.
