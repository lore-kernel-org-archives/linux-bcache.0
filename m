From: CoRpO <corpo-Zp/rcV4kTj0@public.gmane.org>
Subject: Re: Strange behavior
Date: Thu, 14 Mar 2013 15:32:45 +0100
Message-ID: <8f2e763728d77626e40d33b9e2d5f6b2@gruk.org>
References: <d7d9ba24c29c31d9d462490a7e978814@gruk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d7d9ba24c29c31d9d462490a7e978814-Zp/rcV4kTj0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Le 2013-03-14 13:17, CoRpO a =C3=A9crit :

> Hi,
>
> I'm currently running the latest bcache (non-dev) on an ubuntu 12.04,
> and it seems to me that bcache doesn't cache anything
>
> The setup is as follow:
>
> - One drive for the system
> - a 480 GB SSD caching device (/dev/sdb)
> - a 10 drives Raid 5 (on a HP P410 controller) backing device
> (/dev/sdc)
> - 36 GB ram
>
> /dev/bcache0 mounted as /home
>
> The server is a file server, with lots of file but few of them served
> frequently. So that's why I've put bcache on it, to have frequently
> asked files on the caching device (which are bigger than the server's
> ram)
>
> I've filled the server with 16 TB of datas, and I see little to no
> usage of /dev/sdb
>
> # iostat -x 30
> avg-cpu: %user %nice %system %iowait %steal %idle
> 0.05 0.00 0.74 10.92 0.00 88.30
>
> Device: rrqm/s wrqm/s r/s w/s rkB/s wkB/s
> avgrq-sz avgqu-sz await r_await w_await svctm %util
> sda 0.00 0.40 0.00 0.83 0.00 5.07
> 12.16 0.00 0.00 0.00 0.00 0.00 0.00
> sdb 0.27 0.03 1.10 0.17 136.57 0.37
> 216.21 0.00 0.95 1.09 0.00 0.53 0.07
> sdc 0.00 0.00 185.53 0.03 23750.93 0.03
> 255.98 3.14 16.90 16.90 0.00 4.40 81.59
> bcache0 0.00 0.00 186.67 0.10 23896.00 0.32
> 255.89 0.00 16.81 16.82 0.00 0.00 0.00
>
> sequential_cutoff and sequential_merge are echoed 0 to disable them,
> because I want sequential IOs to be cached
>
> I get strange numbers from the variables. Some seems to indicate that
> bcache is doing its work, others seems not.
> I'm totally puzzled. Am I doing something wrong ? It bcache suited=20
> for
> what I want to do ? Is it a bug ?
>
> I've even tried to recreate the caching device to get rid of the data
> that was on it during data was put on the backing device.
> As noted in this mailing-list, I made some writes to the device to
> allow the btree to split/grow if needed, and seen no changes.
>
> Here are the details :
>
> # cat /sys/block/bcache0/bcache/cache/internal/active_journal_entries
> 3
>
> # cat /sys/block/bcache0/bcache/cache/internal/bset_tree_stats
> btree nodes: 1
> written sets: 2
> unwritten sets: 1
> written key bytes: 156768
> unwritten key bytes: 96
> floats: 1222
> failed: 63
>
> # cat /sys/block/bcache0/bcache/cache/internal/btree_nodes
> 1
> # cat /sys/block/bcache0/bcache/cache/internal/btree_used_percent
> 46
> # cat /sys/block/bcache0/bcache/cache/average_key_size
> 384k
> # cat /sys/block/bcache0/bcache/cache/btree_cache_size
> 0
> # cat /sys/block/bcache0/bcache/cache/cache_available_percent
> 99
> # cat /sys/block/bcache0/bcache/cache/root_usage_percent
> 47
> # cat /sys/block/bcache0/bcache/cache/tree_depth
> 0
> # cat /sys/block/bcache0/bcache/cache_mode
> writethrough [writeback] writearound none
> # cat /sys/block/bcache0/bcache/readahead
> 1.0M
> # cat /sys/block/bcache0/bcache/stats_hour/bypassed
> 0
> # cat /sys/block/bcache0/bcache/stats_hour/cache_hit_ratio
> 100
> # cat /sys/block/bcache0/bcache/stats_hour/cache_hits
> 960779
> # cat /sys/block/bcache0/bcache/stats_hour/cache_misses
> 0
> # cat /sys/block/bcache0/bcache/stats_hour/cache_readaheads
> 0
> # cat /sys/block/bcache0/bcache/cache/cache0/freelist_percent
> 0
> # cat /sys/block/bcache0/bcache/cache/cache0/priority_stats
> Unused: 89%
> Metadata: 0%
> Average: 4141
> Sectors per Q: 3109760
> Quantiles: [4162 4189 4193 4197 4201 4205 4209 4213 4217 4221 4225
> 4229 4233 4237 4241 4245 4249 4253 4257 4260 4264 4268 4272 4276 4280
> 4284 4288 4292 4296 4300 4304]
> # cat /sys/block/bcache0/bcache/cache/cache0/written
> 47.4G
> # cat /sys/block/bcache0/bcache/cache/cache0/cache_replacement_policy
> [lru] fifo random
> # cat /sys/block/bcache0/bcache/cache/cache0/nbuckets
> 915661
> # cat /sys/block/bcache0/bcache/cache/cache0/metadata_written
> 13.3M
>
> I don't know what to try. At first I used bcache-3.2, and seeing this
> beavior made me switch to bcache and 3.8 kernel. Tried bcache-dev,=20
> too,
> but the server doesn't boot, kernel stuck in a softlock @[bcache:345]
> (no idea of the meaning)
>
> What am I doing wrong ?
> There's little to no activity on the caching device, I though there
> would be write operations to cache served files, but the only writes=20
> are
> when I put new files. The pattern is 99% read of big files (~ from=20
> 100
> MB to 10 GB)
>
> Thank you

In addition, here are the results of a 1 minutes blktrace

Total (sdb):
  Reads Queued:           3,       10KiB  Writes Queued:           8,  =
 =20
    2KiB
  Read Dispatches:        3,       10KiB  Write Dispatches:        8,  =
 =20
    2KiB
  Reads Requeued:         0               Writes Requeued:         0
  Reads Completed:        3,       10KiB  Writes Completed:        8,  =
 =20
    2KiB
  Read Merges:            0,        0KiB  Write Merges:            0,  =
 =20
    0KiB
  IO unplugs:             3               Timer unplugs:           0

Total (sdc):
  Reads Queued:       14674,     1878MiB  Writes Queued:           3,  =
 =20
   10KiB
  Read Dispatches:    14674,     1878MiB  Write Dispatches:        3,  =
 =20
   10KiB
  Reads Requeued:         0               Writes Requeued:         0
  Reads Completed:    14678,     1879MiB  Writes Completed:        3,  =
 =20
   10KiB
  Read Merges:            0,        0KiB  Write Merges:            0,  =
 =20
    0KiB
  IO unplugs:         14674               Timer unplugs:           0

Total (bcache0):
  Reads Queued:       14674,     1878MiB  Writes Queued:           3,  =
 =20
    2KiB
  Read Dispatches:        0,        0KiB  Write Dispatches:        0,  =
 =20
    0KiB
  Reads Requeued:         0               Writes Requeued:         0
  Reads Completed:        0,        0KiB  Writes Completed:        0,  =
 =20
    0KiB
  Read Merges:            0,        0KiB  Write Merges:            0,  =
 =20
    0KiB
  IO unplugs:             0               Timer unplugs:           0
