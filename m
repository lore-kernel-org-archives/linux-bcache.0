From: Michael Lyle <mlyle@lyle.org>
Subject: Writeback efficiency -- proposal
Date: Wed, 20 Sep 2017 01:01:47 -0700
Message-ID: <CAJ+L6qe6=KTXFhss5rfa7g=UCMhp6wwCQ+qL_YZDJq+vWn=PNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:51715 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdITIBs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Sep 2017 04:01:48 -0400
Received: by mail-qt0-f175.google.com with SMTP id q4so1979813qtq.8
        for <linux-bcache@vger.kernel.org>; Wed, 20 Sep 2017 01:01:48 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Hey everyone---

Right now writeback is pretty inefficient.  It lowers the seek
workload some on the disk by doing things in ascending-LBA order, but
there is no prioritization of writing back larger blocks (that is,
doing larger sequential IOs).

At the same time, there is no on-disk index that makes it easy to find
larger sequential pieces.  However, I think it's possible to take a
heuristic approach to make this better.

Proposal--- When gathering dirty chunks--- I would like to track the
median size written back in the last batch of writebacks, and then
skip the first 500 things smaller than the median size.  This still
has the effect of putting all of our writes in LBA order, and has a
relatively minimal cost (having to scan through 1000 dirty things
instead of 500 in the worst case).  Upon reaching the end of the btree
we can revert to accepting all blocks.

Taking a trivial case-- If half of the things to write back are 4k,
and half are 8k, this will make us favor / almost entirely do
writeback of 8k chunks, and will demand 25% fewer seeks to do an
equivalent amount of writeback, in exchange for a small amount of
additional CPU.  (To an extent even this will be mitigated, because we
won't have to scan to find dirty blocks as often).

Does this sound reasonable?

Thanks!

Mike
