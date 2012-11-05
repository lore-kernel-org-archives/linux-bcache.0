From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: Re: Kernel Oops (bCache hangs on registering 3rd device)
Date: Mon, 5 Nov 2012 13:15:21 +0000 (UTC)
Message-ID: <loom.20121105T140203-975@post.gmane.org>
References: <loom.20121104T035737-445@post.gmane.org> <loom.20121105T135531-268@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

James Sefton <james@...> writes:

> 
> James Sefton <james@...> writes:
> 
> > 
> > Hi,
> > 
> > Seems I broke something.
> > <.. pruned previous post ..>
> 
> Yes, reproduced it after a clean boot.
> It gets stuck creating the third cache device. (/dev/bcache2)
> 
> Here is the latest info from kern.log, but it looks very similar to what I 
> posted before.
> 
> http://pastebin.com/r8YRSNGR
> 
> Any idea if I am doing something wrong or is this a bug?
> I need to create up to 64 cache devices.  Possibly slightly over that on rare 
> occasions.  (The majority of servers will have 16-32)
> 
> Many Thanks,
> 
> James
> 
> 


Aha,  I have more information.

ls /dev/block -l

<filtered results to relevant>
lrwxrwxrwx 1 root root 10 Nov  5 12:51 252:0 -> ../bcache0
lrwxrwxrwx 1 root root 10 Nov  5 12:51 252:1 -> ../bcache1
lrwxrwxrwx 1 root root 12 Nov  5 12:51 252:2 -> ../bcache1p1


Our script does things in the following order:
1. Registers bcache0 - OK
 - links bcache0 in /dev/block/252:0
2. Registers bcache1 - OK
 - links bcache1 in /dev/block/252:1
3. Partitions bcache1 - OK  (single partition at the moment)
 - links bcache1p1 in /dev/block/252:2
4. Partitions bcache0 - Partition table writes okay, but bcache0p1 does not get 
created.
 - presumably attempts to link /dev/block/252:1 or something, and fails.
5. Registers bcache2 - FAIL, prevents any further bcache devices being 
registered and prevents system shut-down.
 - attempts to link bcache2 in /dev/block/252:2, which is already used for 
bcache1p1.

Probably explains why this has not been seen before since we only just added 
support for partitions with the patch details you recently gave me.

Any chance of a patch to fix the numbering?
(I wish my C++ was up to scratch so that I could do it myself as it looks like 
it could be relatively simple!)

Many Thanks,

James
