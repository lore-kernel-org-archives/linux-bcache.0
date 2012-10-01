From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Mon, 1 Oct 2012 20:56:21 +0000 (UTC)
Message-ID: <loom.20121001T223817-249@post.gmane.org>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com> <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com> <loom.20120928T010314-562@post.gmane.org> <20120928185949.GA7062@google.com> <loom.20121001T211315-779@post.gmane.org> <20121001193806.GA26488@google.com> <loom.20121001T220412-225@post.gmane.org> <20121001203706.GB26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <koverstreet@...> writes:

> 
> On Mon, Oct 01, 2012 at 08:05:14PM +0000, Brad Walker wrote:
> > Kent Overstreet <koverstreet@...> writes:
> > 
> > > 
> > > What about cache_bypass_hits, cache_bypass_misses?
> > > 
> > 
> > cache_bypass_hits = 0
> > cache_bypass_misses = 0
> 
> I should've just asked you for all the stats - what about
> cache_miss_collision?

bwalker:/sys/fs/bcache/dd10d09c-0605-462c-af85-8466b0aa2017/stats_total> ls
bypassed           cache_bypass_misses  cache_hits             cache_misses
cache_bypass_hits  cache_hit_ratio      cache_miss_collisions  cache_readaheads
bwalker:/sys/fs/bcache/dd10d09c-0605-462c-af85-8466b0aa2017/stats_total> cat *
0
0
0
98
162315691
0
2329081
0
bwalker:/sys/fs/bcache/dd10d09c-0605-462c-af85-8466b0aa2017/stats_total>


> Also, internal/cache_read_races?

cat /sys/fs/bcache/dd10d09c-0605-462c-af85-8466b0aa2017/interna/cache_read_races

0

> Perhaps stuff is getting evicted from the cache for some reason... How
> big is the SSD?

nellis: # sg_inq /dev/rssda
ATA device: model, serial number and firmware revision:
  Micron P320h-MTFDGAR350SAH               000000001143020287B2 B1490300
nellis: # fdisk /dev/rssda

The device presents a logical sector size that is smaller than
the physical sector size. Aligning to a physical sector (or optimal
I/O) size boundary is recommended, or performance may be impacted.

Command (m for help): p

Disk /dev/rssda: 350.1 GB, 350078754816 bytes
210 heads, 56 sectors/track, 58141 cylinders, total 683747568 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x16e1596f

     Device Boot      Start         End      Blocks   Id  System
/dev/rssda1            2048   683747567   341872760   83  Linux

Command (m for help):


> Is cache_replacement_policy lru? (the default - cache_replacement_policy
> is in cache0/)

LRU

> What's cache0/priority_stats say?
> 

nellis: # cat priority_stats
Unused:         97%
Metadata:       0%
Average:        0
Sectors per Q:  582336
Quantiles:      [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1]
nellis: #
