From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Btree node merging is now in the bcachefs-testing branch
Date: Tue, 15 Nov 2016 09:31:07 -0900
Message-ID: <20161115183107.m2sucu5okqzzftoi@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35266 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbcKOSbL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Nov 2016 13:31:11 -0500
Received: by mail-pg0-f65.google.com with SMTP id p66so12441029pga.2
        for <linux-bcache@vger.kernel.org>; Tue, 15 Nov 2016 10:31:11 -0800 (PST)
Received: from kmo-pixel (213-168-42-72.gci.net. [72.42.168.213])
        by smtp.gmail.com with ESMTPSA id s2sm45301971pfi.10.2016.11.15.10.31.08
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Nov 2016 10:31:09 -0800 (PST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Finally got the regressions in the whiteout compaction and btree locking changes
fixed - those have now been merged into bcache-dev. We should hopefully be
_finally_ ready to merge in foreground btree node merging, once it's had a bit
more testing to very no new or exposed regressions.

Besides the memcpy() bug in the whiteout compaction code, the other bug was in
the new btree_iter_traverse_error() code - it wasn't reinitializing sorted_iters
in a retry path, causing it to go into an infinite loop - but I don't think
anyone besides me was seeing this.

After btree node merging goes in, then next thing I'm working on is more
performance improvements related to btree node writes and further improvements
to handling of whiteouts. I'm planning on writing up a longer post explaining
what's changing, but for now suffice it to say when I'm finished we ought to be
beating the _pants_ off ext4/xfs/btrfs across the board.
