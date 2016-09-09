From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Thu, 8 Sep 2016 17:56:29 -0800
Message-ID: <20160909015629.356sy3q4gg35szbn@kmo-pixel>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35522 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbcIIB4d (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Sep 2016 21:56:33 -0400
Received: by mail-pa0-f67.google.com with SMTP id pp5so3111041pac.2
        for <linux-bcache@vger.kernel.org>; Thu, 08 Sep 2016 18:56:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Sep 07, 2016 at 01:12:12PM -0800, Kent Overstreet wrote:
> So, right now we're checking i_nlinks on every mount - mainly the dirents
> implementation predates the transactional machinery we have now. That's almost
> definitely what's taking so long, but I'll send you a patch to confirm later.

I just pushed a patch to add printks for the various stages of recovery: use
mount -o verbose_recovery to enable.

How many files does this filesystem have? (df -i will tell you).

As another data point, on my laptop mounting takes half a second - smallish
filesystem though, 47 gb of data and 711k inodes (and it's on an SSD). My
expectation is that mount times with the current code will be good enough as
long as you're using SSDs (or tiering, where tier 0 is SSD) - but I could use
more data points.

Also, increasing the btree node size may help, if you're not already using max
size btree nodes (256k). I may readd prefetching to metadata scans too, that
should help a good bit on rotating disks...

Mounting taking 12 minutes (and the amount of IO you were seeing) implies to me
that a metadata isn't being cached as well as it should be though, which is odd
considering outside of journal replay we aren't doing random access, all the
metadata access is inorder scans. So yeah, definitely want that timing
information...
