From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: Always cache?
Date: Sat, 3 Nov 2012 18:53:14 +0000 (UTC)
Message-ID: <loom.20121103T193709-932@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

I am trying to configure the cache to always cache.
The only time I want it to bypass the cache is when it has to.  (ie.. cache 
full)

In particular - I want all writes to hit the writeback cache and never be 
written directly. (Unless no space is left for writeback)

I am not sure how to configure this.  I thought I had done it once before but I 
cant seem to reproduce it.

Here are my settings so far:

/sys/block/bcache0/bcache/

cache_mode = writethrough [writeback] writearound none
readahead = 0
running = 1
sequential_cutoff = 0 (also tried this at 1.1G, which appears to be maximum)
sequential_merge = 1 (also tried 0.  I have no idea what this means)
state = clean
writeback_delay = 30
writeback_metadata = 1 (not sure what this does)
writeback_percent = 40 (also tried at 10)
writeback_running = 1


not sure what else there is to configure.
Any suggestions would be appreciated.

I am basically trying to maintain responsive disk access as much as possible.  
The backing storage is on a slow link to a SAN and when accessed directly is 
relatively slow.  I want it to use the cache as much as is possible and then 
bCache write the cache data to the backend storage behind the scenes.  Workload 
is mixed..  random and sequential reads and writes, anything from just a few 
bytes to 4-5Gb files.

I am guessing that sequential_cutoff = 0 disables the cut-off feature.  (I tried 
the max of 1.1G too, just in case)

I am using nmon to monitor where data is being written while copying /usr into 
the filesystem on cache0p1. (ext4)   I am seeing writes going to the cache 
device and the backing device simultaneously - but the cache is not written to 
heavily.  Performance seen when copying is similar to that of if I was just 
writing to the backing device directly.  (maybe a little better since some bits 
are getting written to the cache)

Any suggestion what I may be doing wrong?

Cheers,

James
