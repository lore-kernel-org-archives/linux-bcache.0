From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache-3.2 branch
Date: Tue, 10 Jul 2012 02:32:36 +1000
Message-ID: <CAOzFzEjovYu4eE9E_asOBVyBhqFuvhgzJ7UFyESLY0XycAfkuA@mail.gmail.com>
References: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w@mail.gmail.com>
	<20120709155734.GA23774@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120709155734.GA23774-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 10 July 2012 01:57, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Jun 20, 2012 at 10:08:51PM +1000, Joseph Glanville wrote:
>> Hi Kent and list,
>>
>> I have pulled down the latest bcache code and have been playing around
>> with it when I noticed that I am having issues starting Xen virtual
>> machines using bcache + LVM.
>> What is interesting is the QEMU storage emulation in userspace is able
>> to access the device fine however blkback kernel module which uses the
>> device directly seems to fail.
>> How would I go about debugging any of this?
>>
>> Older versions of bcache work fine so it's a regression as far as I can tell.
>
> Hey, sorry for the delay - I just got back from my first sort-of
> vacation in... awhile :P
>
> I'm pretty sure I know the approximate source of the regression - I
> fairly recently reworked some code in the generic block layer to handle
> arbitrary size bios (which enabled some major cleanups in the bcache
> code). I've chased down a few bugs with that code since then.
>
> Got some logs for me to look at? Or did you want me to give you pointers
> on debugging kernel code? :)

A few pointers would be great. :)

Also how do I best get it to do a really verbose log that I can use to
help you track down bugs?

>
>>
>> Joseph.
>>
>> --
>> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
>> Phone: 1300 56 99 52 | Mobile: 0428 754 846

Cheers,
Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
