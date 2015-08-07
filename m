From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Thu, 06 Aug 2015 22:21:25 -0700
Message-ID: <1438924885.31517.11.camel@hasee>
References: <20150717235133.GC4166@kmo-pixel> <1437177497.9298.3.camel@ssi>
	 <20150718021007.GA3196@kmo-pixel> <1437196863.4737.2.camel@hasee>
	 <CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
	 <20150724191557.GA1928@kmo-pixel> <1437770866.21988.16.camel@ssi>
	 <CAF1ivSZhj2WuafP0yFey47OyAhjF7-Sznnb1WBXA+Hm5Rem31Q@mail.gmail.com>
	 <CAF1ivSZKw4Te-hixrbeq1bWUfkrQT-gjroG7jF+1Tm8sc+Pp=A@mail.gmail.com>
	 <1438843206.9429.34.camel@hasee> <20150806231112.GB2459@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56582 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbbHGFV2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 7 Aug 2015 01:21:28 -0400
In-Reply-To: <20150806231112.GB2459@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Thu, 2015-08-06 at 16:11 -0700, Kent Overstreet wrote:
> On Wed, Aug 05, 2015 at 11:40:06PM -0700, Ming Lin wrote:
> > On Tue, 2015-07-28 at 11:45 -0700, Ming Lin wrote:
> > > On Tue, Jul 28, 2015 at 11:41 AM, Ming Lin <mlin@kernel.org> wrote:
> > > > On Fri, Jul 24, 2015 at 1:47 PM, Ming Lin <mlin@kernel.org> wrote:
> > > >>
> > > >> And I want to learn how the btree node insert/delete/update happens on
> > > >> disk. These maybe too detail. I'm going to write a small tool to dump
> > > >> the file system. Then I could understand better the on disk btree
> > > >> format.
> > > >
> > > > Here is my simple tool to dump parts of the on-disk format.
> > > > http://www.minggr.net/cgit/cgit.cgi/bcache-tools/commit/?id=deb258e2
> > > 
> > > Actually: http://www.minggr.net/cgit/cgit.cgi/bcache-tools/commit/?id=3121eec
> > > 
> > > >
> > > > It's not in good shape, but simple enough to learn the on-disk format.
> > 
> > Hi Kent,
> > 
> > I'm trying to understand how the root inode is stored in the inode
> > btree.
> > 
> > dd if=/dev/zero of=fs.img bs=10M count=1
> > bcacheadm format -C fs.img
> > mount -t bcache -o loop fs.img /mnt
> > umount /mnt
> > hexdump -C fs.img > fs.hex
> > 
> > From my simple tool, I know that the inode btree starts from offset
> > 0xec000
> 
> The root node of the inode btree? Are you handling trees with multiple nodes
> yet?

Yes and no.

> 
> > 
> > 000ec000  43 ef f3 df ff ff ff ff  86 c1 47 1e 99 25 51 35  |C.........G..%Q5|
> > 000ec010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 000ec020  00 00 00 00 00 00 00 00  ff ff ff ff ff ff ff ff  |................|
> > 000ec030  ff ff ff ff ff ff ff ff  01 05 00 00 00 00 00 00  |................|
> > 000ec040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 000ec070  88 b5 38 e2 45 36 eb f6  00 00 00 00 00 00 00 00  |..8.E6..........|
> > 000ec080  01 00 00 00 03 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 000ec090  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 000ed000  31 66 fd 31 ff ff ff ff  88 b5 38 e2 45 36 eb f6  |1f.1......8.E6..|
> > 000ed010  02 00 00 00 00 00 00 00  01 00 00 00 03 00 0b 00  |................|
> > 000ed020  0b 01 80 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 000ed030  00 00 00 00 00 00 00 00  00 10 00 00 00 00 00 00  |................|
> > 000ed040  ed 41 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |.A..............|
> > 000ed050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 000ed070  02 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 000ed080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 
> > btree_node (0xec000)
> >     bset (0xed008)  ---> bset->u64s = 0x0b = 11
> >         bkey_packed (0xed020)
> >             bkey (0xed020)
> >             bch_inode (0xed040 to 0xed077)  ---> root inode
> > 
> > Is the decode above correct?
> 
> I think so. The code that deals with reading in a btree node disk and
> interpreting the contents is mainly in bch_btree_node_read_done(), btree_io.c -
> it looks like you found that?

I haven't dig into the code yet.
Firstly to understand the on-disk structure by hexdump.

> 
> > I found the root inode manually. But how is it actually found by code?
> 
> The root inode is the inode with inode number BCACHE_ROOT_INO (4096) -
> http://evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/fs.c?h=bcache-dev&id=5cf7fb11d124839eea2191fd7e8eddecb296d67d#n2285
> 
> So to do it correctly, you'll need the bkey packing code in order to unpack the
> key (if it was packed) so that you can get the actual inode number of the key.
> 
> You'll also need to do something like the mergesort algorithm (or something
> equivalent; you don't need to do the actual mergesort if you're just doing a
> linear search for one key). That is - if there's multiple bsets, they will
> likely contain duplicates and keys in newer bsets overwrite keys in older bsets.

Don't understand this part for now. I'll learn it.

> 
> > Could you help to explain what it is from 0xec070 to 0xed007?
> > Are they also bsets?
> 
> Without knowing your block size and spending a fair amount of time staring at
> the hexdump, I don't know what starts there - but quite possibly yes; bsets that
> aren't at the start of the btree node are embeddedd in a struct
> btree_node_entry, not a struct btree_node.
> 
> To tell if it's a valid bset, you compare bset->seq against the seq in the first
> bset - it's a random number generated for each new btree node; if they match
> then the bset there goes with that btree node.

The block size is 4K.

OK, now I can interpret the hexdump.

000ec000  43 ef f3 df ff ff ff ff  86 c1 47 1e 99 25 51 35  |C.........G..%Q5|
000ec010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000ec020  00 00 00 00 00 00 00 00  ff ff ff ff ff ff ff ff  |................|
000ec030  ff ff ff ff ff ff ff ff  01 05 00 00 00 00 00 00  |................|
000ec040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000ec070  88 b5 38 e2 45 36 eb f6  00 00 00 00 00 00 00 00  |..8.E6..........|
000ec080  01 00 00 00 03 00 00 00  00 00 00 00 00 00 00 00  |................|
000ec090  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000ed000  31 66 fd 31 ff ff ff ff  88 b5 38 e2 45 36 eb f6  |1f.1......8.E6..|
000ed010  02 00 00 00 00 00 00 00  01 00 00 00 03 00 0b 00  |................|
000ed020  0b 01 80 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000ed030  00 00 00 00 00 00 00 00  00 10 00 00 00 00 00 00  |................|
000ed040  ed 41 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |.A..............|
000ed050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000ed070  02 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000ed080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000ee000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

There are 2 bsets: bset->seq "88 b5 38 e2 45 36 eb f6"

btree_node (0xec000)
    bset_1 (0xec070)  ---> bset->u64s = 0 (a empty bset?)

btree_node_entry (0xed000)
    bset_2 (0xed008)  ---> bset->u64s = 0x0b = 11
        bkey_packed (0xed020)
            bkey (0xed020)
            bch_inode (0xed040 to 0xed077)  ---> root inode

Why is there a empty bset at the start of the btree node?
