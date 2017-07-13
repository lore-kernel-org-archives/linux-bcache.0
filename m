From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] bcache: only recovery I/O error for writethrough mode
Date: Thu, 13 Jul 2017 00:53:55 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707130012390.9683@mail.ewheeler.net>
References: <20170710111828.97918-1-colyli@suse.de> <OFCB2AA6A0.E15FCC3D-ON4825815B.0001EEF5-4825815B.00033093@zte.com.cn> <eb85fc2b-91d9-0344-829c-972803572ac1@suse.de> <OFAAA836F5.65C1F846-ON4825815B.00093270-4825815B.0009741B@zte.com.cn>
 <45926957-5990-6520-7bd7-6de8c2bae7b8@suse.de> <OF7159B9D9.1C66A3AE-ON4825815B.000AD084-4825815B.000B252E@zte.com.cn> <be0287d1-9af2-659c-0d40-5fb774e3b178@suse.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-235402074-1499907238=:9683"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <be0287d1-9af2-659c-0d40-5fb774e3b178@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: tang.junhui@zte.com.cn, linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-235402074-1499907238=:9683
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 12 Jul 2017, Coly Li wrote:

> On 2017/7/12 上午10:01, tang.junhui@zte.com.cn wrote:
> >>I meant "it is very necessary for data base applications which always
> >>use *writeback* mode and not switch to other mode during all their
> >>online time."  ^_^
> > 
> > I know, it is necessary, but not enough. who can promise they will not
> > switch during online time? This patch is logical imperfectly.
> 
> Yes, I agree with you. Since Eric mentions dirty data map, an improved
> fix shows up in my head,
> 
> When cache device disconnected from system,
> 0) If in non mode, do nothing.

Does non mode guarantee that nothing is dirty?  I'm not convinced of that.  
I think you can set non mode with dirty blocks. (Correct me if I'm wrong 
here.)

> 1) If in writeback/writethough/writearound mode, and dirty map is clean,
>    - switch to non mode
>    - continue to handle I/O without cache device

Sure, that makes sense.  

> 2) If in writeback mode, and dirty map is not clean,

You would want to do a dirty map lookup for each IO.  How about this:

2) If in _any_ mode, and dirty map is dirty for *that specific block*:

  If WRITE request completely overlaps the dirty segment then clear 
	the dirty flag and pass through to the backing dev.
  otherwise:
    - return -EIO immediately for WRITE request
    - return -EIO immediately for READ request (*)

If the WRITE request completely overlaps the dirty segment as indicated 
from the in-memory metadata, then clear its dirty flag and write to the 
backing device.  Whatever was dirty isn't important anymore as it was 
overwritten.

Unless there is a good reason to diverge, we would want this recovery 
logic would be the same for failed IOs from an existing cachedev (eg, with 
badblocks), and for cachedevs that are altogether missing.


> 3) If not in writeback mode, and dirty map is not clean. It means the
> cache mode is switched from writeback mode with dirty data lost, then
>    - returns -EIO immediately for WRITE request
>    - returns -EIO immediately for READ request (*)

For #2,3, do a dirty map lookup for every IO: if the block is clean, pass 
it to the backing device.  Only -EIO if the request cannot be recovered 
(block is dirty) and invoke pr_crit_once() to notify the user.  We want 
all IO requests to succeed to the extent possible.

I think #3 is the same case as #2.  The logic is the same whether its is 
now or ever was in writeback mode, regardless of the current mode.
 
> (*) NOTE:
> A sysfs entry "recovery_io_error" can be add here, which is disabled as
> default. If it is enabled, if a READ request does not hit dirty map,
> bcache will provide it from backing device.

Resilience first!  This should default on.  

Sometimes systems run for months with bad sectors, and this case is no 
different.  Let the bcache users' IOs succeed if possible but notify them 
with pr_crit_once().

A reboot might loose data.  They could be lucky with important data in the 
page cache; notifying them without killing the device because it is dirty 
might give them a chance to do a hot backup before rebooting (or 
stop/starting bcache).

Since the dirty map is still in memory, that information is 
useful for recovery.  After a reboot the dirty map is lost---and with it 
the data about what is consistent and what is not. 

For example, if LVM snapshots sit atop of the bcache volume, then you 
could `dd` them off.  If you hit an error, you know that copy is at least 
partially inconsistent and can try an older snapshot until one is found 
which is old enough to be 100% consistent.  Without the dirty map, you 
would only be guessing at which volume is actually consistent.

Let users set recovery_io_error=0 for those who really want to fail early.

--
Eric Wheeler
--1641074820-235402074-1499907238=:9683--
