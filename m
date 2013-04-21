From: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Subject: Re: bcache hangs with continuous write I/O to SSD device: me too
Date: Sun, 21 Apr 2013 15:39:33 +0300 (EEST)
Message-ID: <alpine.DEB.2.02.1304211532440.31363@orbit.lan>
References: <alpine.DEB.2.02.1304181413360.30807@orbit.lan> <20130420230047.GA22470@moria.home.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130420230047.GA22470-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sat, 20 Apr 2013, Kent Overstreet wrote:

> On Thu, Apr 18, 2013 at 02:42:59PM +0300, Juha Aatrokoski wrote:
>> I ran into the same bug as Heiko Wundram reported a while back:
>> after a few (2-4) days of normal desktop usage, bcache hangs and
>> dstat shows continuous 50MB/s write to the cache SSD partition with
>> one CPU core maxed out in IO wait. I remembered Kent's answer to the
>> later message, and at least echoing 0 to writeback_running did
>> nothing in my system. The bcache device consists of an SSD partition
>> and two disks in md raid0, and there is dmcrypt on top of bcache.
>>
>> The branch was bcache patched to a 3.7.10 (Gentoo) kernel. Is bcache
>> the correct branch, or should I be using bcache-for-upstream? (There
>> are many branches in the git repo, but I can't find any
>> documentation/description on what they are and who should use them.)
>>
>> I had to revert back to the previous setup, which was bcache-3.2
>> patched to a 3.6.11 kernel and which doesn't have the problem. But
>> it looks like bcache-3.2 cannot be trivially (i.e. without more
>> detailed knowledge about bcache and the bio subsystem) ported to 3.7
>> kernels, so I guess I'll be stuck with 3.6 until the bug is fixed.
>
> Thanks for checking writeback_running - so, it's probably not background
> writeback, sounds like it's actually the new allocation code.
>
> Can you tell me anything about your setup? In particular, are you
> running on device mapper/lvm?

As mentioned above, the block device stack is as follows:

   dmcrypt
     bcache0
       sda3 (SSD)
       md0 (raid0)
         sdb
         sdc
