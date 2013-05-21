From: folkert <folkert-Beo89p9qyDM6GGFevw1D/A@public.gmane.org>
Subject: speed
Date: Tue, 21 May 2013 14:19:30 +0200
Message-ID: <20130521121928.GO10944@belle.intranet.vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I've got a couple of questions regarding bcache:

- will it be faster to implement bcache instead of letting the
  write-intent-map of a raid1 volume be written on an ssd together with
  the journals of the filesystems on that raid1 volume?

- if i have multiple logical volumes in a volume group, do I need to
  explicitly configure bcache for each of them? or can I "connect" bcache
  to the whole volume group?

- does bcache do trim? and/or pass it through?

- maybe bcache can check if a written block is all 0x00 and then do a
  trim instead? that is not only usefull for SSDs but can help
  data-deduplication software/appliances as well

- what will happen if an SSD suddenly stops working in the sense that it
  won't allow anymore writes? will bcache then still commit all the
  buffered data which was already written to the SSD but not to the HDDs?

- any suggestions what SSD to buy? e.g. an OCZ Vertex 4?

- are there any suggestions on what size SSD to use for a certain size
  HDD? or does it depend on the amount of data written per second? or
  the number of iops?

- is it possible to do an emergency flush where everything in the cache
  is written to disk, *as much as possible*? e.g. if a read fails,
  continue with other blocks?
  I'm asking this as I'm not entirely convinced of the quality of SSDs

- is it possible to use more than 1 SSD as a bcache for the same
  storage? not as raid0 as you then can't remove one from the system
  without affecting the other

- does bcache work with e.g. iscsi/nbd remote storage?
  - then maybe it would be nice if it is possible to temporarily bring
    down the remote-storage + bcache combination when the network
    connection goes down

- is it possible to swap via bcache?

- maybe zcache can be combined so that you can work with more data with
  a smaller SSD?

- I think I read on the website that blocks are stored in sorted order
  on disk. that's probably on the HDD below it and not on the SSD,
  right? (because afaik an ssd has always the same access latency,
  independent of write order. altough I can image if that is not true)

- does it keep track of checksums/crcs of the data it writes to the SSD?
  e.g. it writes a block to the SSD and then later on it reads that
  block back from the SSD (to write to e.g. HDD) and verifies that what
  it got back is what it expected


Folkert van Heusden

-- 
Always wondered what the latency of your webserver is? Or how much more
latency you get when you go through a proxy server/tor? The numbers
tell the tale and with HTTPing you know them!
                                     http://www.vanheusden.com/httping/
-----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
