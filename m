From: Thomas Fjellstrom <thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org>
Subject: Re: recomended bcache setup
Date: Wed, 26 Dec 2012 12:01:07 -0700
Message-ID: <201212261201.07192.thomas@fjellstrom.ca>
References: <201212212006.41906.thomas@fjellstrom.ca> <201212240120.34879.thomas@fjellstrom.ca> <20121226184726.GB20185@google.com>
Reply-To: thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121226184726.GB20185-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed Dec 26, 2012, you wrote:
> On Mon, Dec 24, 2012 at 01:20:34AM -0700, Thomas Fjellstrom wrote:
> > On Fri Dec 21, 2012, Thomas Fjellstrom wrote:
> > > I'm setting up a little home NAS here, and I've been thinking about
> > > using bcache to speed up the random access bits on the "big" raid6
> > > array (7x2TB).
> > > 
> > > How does one get started using bcache (custom patched kernel?), and
> > > what is the recommended setup for use with mdraid? I remember reading
> > > ages ago that it was recommended that each component device was
> > > attached directly to the cache, and then mdraid put on top, but a
> > > quick google suggests putting the cache on top of the raid instead.
> > > 
> > > Also, is it possible to add a cache to an existing volume yet? I have a
> > > smaller array (7x1TB) that I wouldn't mind adding the cache layer to.
> > 
> > I just tried a basic setup with the cache ontop of the raid6. I ran a
> > quick iozone test with the default debian sid (3.2.35) kernel, the
> > bcache (3.2.28) kernel without bcache enabled, and with bcache enabled
> > (See below).
> > 
> > Here's a little information:
> > 
> > system info:
> > 	Intel  S1200KP Motherboard
> > 	Intel Core i3 2120 CPU
> > 	16GB DDR3 1333 ECC
> > 	IBM M1015 in IT mode
> > 	7 x 2TB Seagate Barracuda HDDs
> > 	1 x 240 GB Samsung 470 SSD
> > 
> > kernel: fresh git checkout of the bcache repo, 3.2.28
> > 
> > 
> > 
> > Raid Info:
> > 
> > /dev/md0:
> >         Version : 1.2
> >   
> >   Creation Time : Sat Dec 22 03:38:05 2012
> >   
> >      Raid Level : raid6
> >      Array Size : 9766914560 (9314.46 GiB 10001.32 GB)
> >   
> >   Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
> >   
> >    Raid Devices : 7
> >   
> >   Total Devices : 7
> >   
> >     Persistence : Superblock is persistent
> >     
> >     Update Time : Mon Dec 24 00:22:28 2012
> >     
> >           State : clean
> >  
> >  Active Devices : 7
> > 
> > Working Devices : 7
> > 
> >  Failed Devices : 0
> >  
> >   Spare Devices : 0
> >   
> >          Layout : left-symmetric
> >      
> >      Chunk Size : 512K
> >      
> >            Name : mrbig:0  (local to host mrbig)
> >            UUID : 547c30d1:3af4b2ec:14712d0b:88e4337a
> >          
> >          Events : 10591
> >     
> >     Number   Major   Minor   RaidDevice State
> >     
> >        0       8        0        0      active sync   /dev/sda
> >        1       8       16        1      active sync   /dev/sdb
> >        2       8       32        2      active sync   /dev/sdc
> >        3       8       48        3      active sync   /dev/sdd
> >        4       8       80        4      active sync   /dev/sdf
> >        5       8       96        5      active sync   /dev/sdg
> >        6       8      112        6      active sync   /dev/sdh
> > 
> > Fs info:
> > root@mrbig:~/build/bcache-tools# xfs_info /dev/bcache0
> > meta-data=/dev/bcache0  isize=256    agcount=10, agsize=268435328 blks
> > 
> >          =               sectsz=512   attr=2
> > 
> > data     =               bsize=4096   blocks=2441728638, imaxpct=5
> > 
> >          =               sunit=128    swidth=640 blks
> > 
> > naming   =version 2      bsize=4096   ascii-ci=0
> > log      =internal       bsize=4096   blocks=521728, version=2
> > 
> >          =               sectsz=512   sunit=8 blks, lazy-count=1
> > 
> > realtime =none           extsz=4096   blocks=0, rtextents=0
> > 
> > 
> > 
> > 
> > iozone -a -s 32G -r 8M
> > 
> >                                                      random  random   
> >                                                      bkwd   record  
> >                                                      stride
> >        
> >        KB  reclen   write rewrite    read    reread    read   write   
> >        read  rewrite     read   fwrite frewrite   fread  freread
> > 
> > w/o cache (debian kernel 3.2.35-1)
> > 33554432    8192  212507  210382   630327   630852  372807  161710 
> > 388319  4922757   617347   210642   217122  717279   716150 w/ cache 
> > (bcache git kernel 3.2.28):
> > 33554432    8192  248376  231717   268560   269966  123718  132210 
> > 148030  4888983   152240   230099   238223  276254   282441 w/o cache
> > (bcache git kernel 3.2.28):
> > 33554432    8192  277607  259159   709837   702192  399889  151629 
> > 399779  4846688   655210   251297   245953  783930   778595
> > 
> > Note: I disabled the cache before the last test, unregistered the device
> > and "stop"ed the cache. I also changed the config slightly for the
> > bcache kernel, I started out with the debian config, and then switched
> > the preemption option to server, which may be the reason for the
> > performance difference between the two non cached tests.
> > 
> > I probably messed up the setup somehow. If anyone has some tips or
> > suggestions I'd appreciate some input.
> 
> So you probably didn't put bcache in writeback mode, which would explain
> the write numbers being slightly worse.

Yeah, I didn't test in writeback.

> Something I noticed myself with bcache on top of a raid6 is that in
> writeback mode sequential write throughput was significantly worse - due
> to the ssd not having as much write bandwidth as the raid6 and bcache's
> writeback having no knowledge of the stripe layout.

Yeah, I think the SSD I'm using is limited to about 200MB/s sequential write, 
which is probably half of what the raid may be capable of. I could pick up 
another more modern SATA III SSD to remedy that, and I might. But It isn't too 
terribly important. It's random writes I really want to take care of, since 
those really kill performance.

> This is something I'd like to fix, if I ever get time. Normal operation
> (i.e. with mostly random writes) was vastly improved, though.
> 
> Not sure why your read numbers are worse, though - I haven't used iozone
> myself so I'm not sure what exactly it's doing.
> 
> It'd useful to know what iozone's reads look like - how many in flight
> at a time, how big they are, etc.
> 
> I suppose it'd be informative to have a benchmark where bcache is
> enabled but all the reads are cache misses, and bcache isn't writing any
> of the cache misses to the cache. I think I'd need to add another cache
> mode for that, though (call it "readaround" I suppose).
> 
> I wouldn't worry _too_ much about iozone's numbers, I suspect whatever
> it's doing differently to get such bad read numbers isn't terribly
> representative. I'd benchmark whatever you're using the server for, if
> you can. Still be good to know what's going on, there's certainly
> something that ought to be fixed.

I'm betting most of it is pure un-cached reads. I don't know though if it 
keeps the same file around between tests or not. If it does, then things 
should improve significantly after the random write test I should think. But 
it doesn't really. I wasn't too concerned about the initial read tests, but 
I'd have thought it'd at least match or come in slightly under the actual 
numbers without the cache. I remember reading before that bcache has been 
shown to at most add a very slight amount of overhead, if any at all.
 
> Oh, one thing that comes to mind - there's an issue with pure read
> workloads in the current stable branch, where inserting data from a
> cache miss will fail to update the index if the btree node is full (but
> after the data has been written to the cache). This shows up in
> benchmarks, because they tend to test reads and writes separately, but
> it's not an issue in any real world workload I know of because any
> amount of write traffic keeps it from showing up, as the btree nodes
> will split when necessary on writes.
> 
> I have a fix for this in the dev branch, and I think it's stable but the
> dev branch needs more testing.

Ah ok, I'll have to test that. I remember reading about that on the list here. 
I'll test that and get back to you

> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Thomas Fjellstrom
thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org
