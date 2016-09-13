From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Mon, 12 Sep 2016 18:35:14 -0800
Message-ID: <20160913023514.j5kcmiz3kn6iw53l@kmo-pixel>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
 <20160909090049.o45khhwy5t52icch@kmo-pixel>
 <9c9e7ab6-a654-635f-a695-033221093dd0@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33469 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbcIMCfT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Sep 2016 22:35:19 -0400
Received: by mail-pf0-f171.google.com with SMTP id g202so58612780pfb.0
        for <linux-bcache@vger.kernel.org>; Mon, 12 Sep 2016 19:35:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <9c9e7ab6-a654-635f-a695-033221093dd0@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Mon, Sep 12, 2016 at 02:59:35PM +0200, Marcin wrote:
> <zfs mode on> Why do I ever need fsck?;) <zfs mode off>

hah :)

> Maybe, near final version of bcachefs, fsck should be started only after
> unclean shutdown?

It's not about unclean shutdown at all, bcache/bcachefs has always been written
to not care about clean vs. unclean shutdown. We don't even have any way of
telling whether the last shutdown was clean or unclean because we really don't
care.

But in the final release we will definitely make it run much less often - right
now, the concern is bugs, anything that fsck finds would be the result of a bug
and if we do ever have that kind of inconsistency I want to know about it sooner
rather than later.

> HDD won't die in the next year or two, are you concerned especially on
> SSD support in bcachefs?

I'm definitely paying more attention to SSD performance than HDD, but I do want
to make it perform well on HDDs too.

> >> >> # time find /mnt/test/ -type d |wc -l
> >> >> 10564259
> >> 
> >> >> real    10m30.305s
> >> >> user    1m6.080s
> >> >> sys     3m43.770s
> >> 
> >> >> # time find /mnt/test/ -type f |wc -l
> >> >> 9145093
> >> 
> >> >> real    6m28.812s
> >> >> user    1m3.940s
> >> >> sys     3m46.210s
> > 
> > Do you know around how long those find operations take on ext4 with 
> > similar
> > hardware/filesystem contents? I hope we don't just suck at walking 
> > directories.
> 
> 
> ext4 with default, 4kB sector size needs at least one hour (I didn't
> wait to the end of test). I think that such comparision with ext4 or
> testing with other btree_node_size needs simple bash script. I'll wait
> with it until OOM fixes will be available in bcache-dev. I've often got
> problems with allocation failure when I played with bcachefs,ext4 and
> milions of directories.

Oh wow, I guess we're not doing so bad after all :)

Sorry I forgot to reply to your email about the OOMs - those messages are
actually nothing to worry about, we have a mempool we use if that allocation
fails (I'll change it to not print out that message now, just got sidetracked).

> I noticed that bcachefs needs a lot lot of less space for keeping info
> about inodes. Are metadata compressed? If yes then I should do
> comparison of filesystems with and without compression.

There is a sort of metadata compression (packed bkeys), but it's not something
you can or would want to turn off. That's only for keys though, not values (i.e.
inodes).

For inodes, the reason we're taking less space is that since we're storing
inodes in a btree, they don't have to be fixed size (or aligned to a power of
two) - which means we don't have to size them for everything we might ever want
to stick in an inode, like ext4 does, we can have just the essential fields in
struct bch_inode and add optional fields later if we need to.

> Additional question:
> Should be https://github.com/koverstreet/linux-bcache/issues using?

Yeah... I'm not a huge fan of github's issue tracker but I'm not going to run
one myself, and we do need to start using one.
