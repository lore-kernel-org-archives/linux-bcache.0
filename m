From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Hangs on bcache on HEAD and bcache-testing when stacking LVM on
 top (?)
Date: Fri, 5 Apr 2013 14:29:57 -0700
Message-ID: <20130405212957.GF15749@google.com>
References: <515D5592.60906@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515D5592.60906-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Apr 04, 2013 at 12:27:30PM +0200, Heiko Wundram wrote:
> Hey!
> 
> I've already written previously about write hangs with bcache in
> "bcache hangs with continuous write I/O to SSD device, bcache device
> stops working", and I thought, that the problem was solved by
> statically building bcache into the kernel, but that does not seem
> to be the case.

Hey - sorry for the delay; I started looking at your original bug report
but I've been moving the past week so I still haven't been able to spend
much time on it.

I did a _bit_ of poking though, and I suspect it's related to background
writeback - any chance you could confirm/deny? Might be worth flipping
off writeback_running when it happens, and seeing if load returns to
normal.

Your bug reports were a big help in figuring that much out though -
thanks!

> I've now encountered something similar, which seems to occur after
> around 3-4 days of usage of the bcache device (I've had it twice
> now). The bcache device (or rather, the devices stacked on the
> bcache device through LVM) hang, and show 100% CPU utilization. All
> other devices which are not on the bcache volume still work
> properly. There's no obvious kernel thread which is taking CPU time
> and blocking the device (as was with the last bug report I noted).
> 
> When the bcache volume is blocked, iostat reports:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda               0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdb               0,00     0,50    0,00    8,50     0,00     0,03
> 6,53     0,06    6,88    0,00    6,88   4,88   4,15
> sdc               0,00     0,50    0,00    8,50     0,00     0,03
> 6,53     0,06    7,24    0,00    7,24   5,29   4,50
> md127             0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> md126             0,00     0,00    0,00    6,50     0,00     0,03
> 8,00     0,00    0,00    0,00    0,00   0,00   0,00
> md125             0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-0              0,00     0,00    0,00    6,50     0,00     0,03
> 8,00     0,13   20,00    0,00   20,00   5,15   3,35
> dm-1              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-2              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> bcache0           0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-3              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-4              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-5              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-6              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     1,00    0,00    0,00    0,00   0,00 100,00
> dm-7              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-8              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     1,00    0,00    0,00    0,00   0,00 100,00
> dm-9              0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-10             0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     3,00    0,00    0,00    0,00   0,00 100,00
> 
> The devices starting with dm-3 are logical volumes in a volume group
> which resides on (the only) physical volume /dev/bcache0, which in
> turn is made up of /dev/sda (SSD device) and /dev/md127 (backing
> volume, kernel RAID1). /dev/md127 is made up of GPT partitions on
> /dev/sdb and /dev/sdc.
> 
> The bcache volume and the cache is set to use 512byte logical
> sectors, which both devices support (although they both have 4k
> physical sectors).
> 
> There's no real clue as to where I might start to look from here. Is
> this a "known" problem when using bcache together with LVM? Memory
> usage does not seem to be a culprit.
> 
> I'm now trying to boot the system using kernel 3.2 (i.e., the
> bcache-3.2 tree), and can report about that.
> 
> Thanks for any pointers!
> 
> -- 
> --- Heiko.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
