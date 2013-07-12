From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: label devices got removed after format
Date: Fri, 12 Jul 2013 11:40:56 +0000 (UTC)
Message-ID: <kroq08$tfo$3@ger.gmane.org>
References: <51DE7E3A.5070709@profihost.ag>
	<20130712012806.GB17799@kmo-pixel> <krom21$tfo$2@ger.gmane.org>
	<51DFDE21.2040309@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, 12 Jul 2013 12:44:49 +0200, Stefan Priebe - Profihost AG wrote:
> Am 12.07.2013 12:33, schrieb Gabriel de Perthuis:
>> On Thu, 11 Jul 2013 18:28:06 -0700, Kent Overstreet wrote:
>>> On Thu, Jul 11, 2013 at 11:43:22AM +0200, Stefan Priebe - Profihost AG wrote:
>>>> Hi,
>>>>
>>>> after doing mkfs.xfs -f /dev/bcache/by-label/mybcachelabel
>>>>
>>>> /dev/bcache/by-label/mybcachelabel gots removed...
>>>>
>>>> Only a reboot brings it back.
>>>>
>>>> Stefan
>>>
> To me it happens alays when a udev event is triggered. It seems the
> label isn't republished. To me the whole Folder /dev/bcache gets removed.
> 
> May i've used the wrong kernel patches on top of 3.10?

After discussing this on IRC:

The Squeeze version of udev chokes on newlines in labels, to the point
that all the device's symlinks are removed; the uuid symlinks aren't
even involved in label uevents.
As a workaround, the latest commit in [1] strips endlines when setting
the label.

[1] https://github.com/g2p/linux/commits/v3.10%2Bbcache-for-3.11
