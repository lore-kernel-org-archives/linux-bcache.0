From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: label devices got removed after format
Date: Fri, 12 Jul 2013 12:44:49 +0200
Message-ID: <51DFDE21.2040309@profihost.ag>
References: <51DE7E3A.5070709@profihost.ag> <20130712012806.GB17799@kmo-pixel> <krom21$tfo$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <krom21$tfo$2@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Am 12.07.2013 12:33, schrieb Gabriel de Perthuis:
> On Thu, 11 Jul 2013 18:28:06 -0700, Kent Overstreet wrote:
>> On Thu, Jul 11, 2013 at 11:43:22AM +0200, Stefan Priebe - Profihost AG wrote:
>>> Hi,
>>>
>>> after doing mkfs.xfs -f /dev/bcache/by-label/mybcachelabel
>>>
>>> /dev/bcache/by-label/mybcachelabel gots removed...
>>>
>>> Only a reboot brings it back.
>>>
>>> Stefan
>>
>> Gabriel - I bet the uevent bcache is emitting is conflicting with the
>> name of an existing label uevent; there'll be a symlink for the
>> filesystem's label - for the same block device - so the mkfs could be
>> causing another uevent to be emitted overwriting our label.
> 
> The uevent property is CACHED_LABEL, a name that shouldn't interfere
> with the cached device's filesystem label.
> 
>> Or maybe the conflict is a bit more subtle - anyways, you added the
>> label uevent code, think you might be able to figure it out?
> 
> I actually can't reproduce this; the link doesn't disappear.

To me it happens alays when a udev event is triggered. It seems the
label isn't republished. To me the whole Folder /dev/bcache gets removed.

May i've used the wrong kernel patches on top of 3.10?

I have 2cd508a73e7f02b6d30bdbf9322d0b9c6e11a58e and
74ba1d388deb5d064414696f83578b0aade4685a

Stefan
