From: Denis Bychkov <manover@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 17 Jul 2015 20:01:43 -0400
Message-ID: <CAO2mnowhZLM45iSYmLCFZKESrNgKCeRPR7io_tQKoU0u2SYm+Q@mail.gmail.com>
References: <20150714005825.GA24027@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33835 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbbGRABo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jul 2015 20:01:44 -0400
Received: by obre1 with SMTP id e1so74713051obr.1
        for <linux-bcache@vger.kernel.org>; Fri, 17 Jul 2015 17:01:44 -0700 (PDT)
In-Reply-To: <20150714005825.GA24027@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com

Hi,

I actually tried to compile that code recently (maybe 5 days ago) and
it did not change since then. There was a bunch of trivial errors,
that I was able to fix - files moved around without #include updated,
types missing. But at some point I ran into something definitely
non-trivial: there is a variable in io.c, which is supposed to have a
node id in it, but the init code commented out and there is no obvious
way to fix it. So I gave up. I definitely tried the branch you are
talking about - bcache-dev.

Here is the I code I mentioned:

static void bch_read_retry(struct bbio *bbio)
{
struct bio *bio = &bbio->bio;
struct bio *parent;
u64 inode;

trace_bcache_read_retry(bio);

/*
* This used to be a leaf bio from bch_read_fn(), but
* since we don't know what happened to the btree in
* the meantime, we have to re-submit it via the
* top-level bch_read() entry point. Before doing that,
* we have to reset the bio, preserving the biovec.
*
* The inode, offset and size come from the bbio's key,
* which was set by bch_read_fn().
*/
//inode = bbio->key.k.p.inode;
parent = bio->bi_private;

bch_bbio_reset(bbio);
bio_chain(bio, parent);

bch_read(bbio->ca->set, bio, inode);
bio_endio(parent, 0);  /* for bio_chain() in bch_read_fn() */
bio_endio(bio, 0);
}


On Mon, Jul 13, 2015 at 8:58 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> Short announcement, because I'm in the process of moving - but I wanted to get
> this out there because the code is up and I think it's reasonably stable right
> now.
>
> Bcachefs is a posix filesystem that I've been working towards for - well, quite
> awhile now: it's intended as a competitor/replacement for ext4/xfs/btrfs.
>
> Current features
>  - multiple devices
>  - replication
>  - tiering
>  - data checksumming and compression (zlib only; also the code doesn't work with
>    tiering yet)
>  - most of the normal posix fs features (no fallocate or quotas yet)
>
> Planned features:
>  - snapshots!
>  - erasure coding
>  - more
>
> There will be a longer announcement on LKML/linux-fs in the near future (after
> I'm finished moving) - but I'd like to get it a bit more testing from a wider
> audience first, if possible.
>
> You need the bcache-dev branch, and the new bcache tools - be warned, this code
> is _not_ compatible with the upstream bcache on disk format:
>
> $ git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcache.git
> $ git clone -b dev http://evilpiepirate.org/git/bcache-tools.git
>
> Then do the usual compiling...
>
> # bcacheadm format -C /dev/sda1
> # mount /dev/sda1 /mnt
>
> The usual caveats apply - it might eat your data, the on disk format has _not_
> been stabilized yet, etc. But it's been reasonably stable for me, and passes all
> but 2-3 of the supported xfstests.
>
> Try it out and let me know how it goes!
>
> Also, programmers please check out the bcache guide - feedback is appreciated:
>
> http://bcache.evilpiepirate.org/BcacheGuide/
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

Denis
