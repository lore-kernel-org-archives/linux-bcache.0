From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 1/2] bcachefs: On disk data structures
Date: Sun, 13 May 2018 18:29:48 -0400
Message-ID: <20180513222948.GA20114@kmo-pixel>
References: <20180508221800.2642-1-kent.overstreet@gmail.com>
 <20180508221800.2642-2-kent.overstreet@gmail.com>
 <dea41935-a52c-e720-0ca3-eef4367d3641@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dea41935-a52c-e720-0ca3-eef4367d3641@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, hare@suse.com
List-Id: linux-bcache@vger.kernel.org

On Sun, May 13, 2018 at 01:30:06PM -0700, Randy Dunlap wrote:
> On 05/08/2018 03:17 PM, Kent Overstreet wrote:
> > + * The btree is the primary structure, most metadata exists as keys in the
> 
> s/,/;/

nitpicky, but ok :P

> > + * various btrees. There are only a small number of btrees, they're not
> > + * sharded - we have one btree for extents, another for inodes, et cetera.
> 
>    or shared?

No, I mean sharded - we're e.g. not splitting up the extents btree into one
btree per inode. 

> > +/* Btree keys - all units are in sectors */
> 
> Are sectors fixed size?  I.e., can 2 different physical storage devices have
> different sized sectors?
> or is this just the "traditional" 512-byte sector?

512 byte sectors.

Multi device filesystems must use the same block size for each device, but
actually it just occurred to me that it probably wouldn't be that difficult to
lift that restriction. The main reason we care about block size is that btree
node entries and journal entries don't record how much padding we wrote - to
figure out where to look for the next journal/btree node entry, we take the size
of the current entry and round it up by the block size.

But adding the block size that particular entry was written with to the header
would be pretty easy.


>                                          to the start of the start  [intentional?]

Whoops, thanks

> I know that you have already answered a few comments about endianness,
> so maybe you answered this and I missed it.
> 
> Can a bcachefs fs be shared, a la NFS?  I.e., can multiple different-endian
> clients be accessing the same bcachefs?

NFS works. I haven't tested NFS to different endian clients, wasn't aware there
was any reason to... are there potential issues there I'm not aware of?
