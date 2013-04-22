From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: backporting bcache-testing to kernel 3.4
Date: Mon, 22 Apr 2013 21:21:00 +0200
Message-ID: <20130422192100.GA16221@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

has anyone succeeded backporting bcache(-testing) branch to kernel 3.4?

I tried to get it working, patching commits from bcache-testing branch
as well as block patches by Kent, on top of Kernel 3.4.23.

* writeback mode
* backing device: MD-RAID0, or a HDD
* cache device: loopback device on tmpfs (for test)
* testing command:
   dd if=/dev/zero of=/dev/bcache0 bs=4K count=1M oflag=sync

Everything works fine, except for a problem of sync operation.
Every write request is being immediately flushed into backing device.
That's actually what I want to avoid in writeback caches.
Observing block I/Os with iostat, it's weird that no data is actually
written to backing device, despite of high IOPs. e.g.:

Device:  rrqm/s   wrqm/s  r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await svctm  %util
vdb      0.00     0.00    0.00 2550.00    0.00     0.00
0.00     2.05       0.81  0.00    0.81    0.26   67.00

If I test bcache-testing branch based on kernel 3.9-rc3, which means
without backporting, then it works well without such massive bogus syncs.
bcache-3.2 is also fine. So I suppose there might be any change on the
block layer between 3.4 and 3.9, making bcache work in such a strange way.

Any idea?

Dongsu
