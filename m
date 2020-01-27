From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] bcache: avoid unnecessary btree nodes flushing in
 btree_flush_write()
Date: Mon, 27 Jan 2020 09:17:41 +0300
Message-ID: <20200127061740.kzggwhgxtmmwy34i@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgA0GRy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Jan 2020 01:17:54 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org

Hello Coly Li,

The patch 2aa8c529387c: "bcache: avoid unnecessary btree nodes
flushing in btree_flush_write()" from Jan 24, 2020, leads to the
following static checker warning:

	drivers/md/bcache/journal.c:444 btree_flush_write()
	warn: 'ref_nr' unsigned <= 0

drivers/md/bcache/journal.c
   422  static void btree_flush_write(struct cache_set *c)
   423  {
   424          struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
   425          unsigned int i, nr, ref_nr;
                                    ^^^^^^

   426          atomic_t *fifo_front_p, *now_fifo_front_p;
   427          size_t mask;
   428  
   429          if (c->journal.btree_flushing)
   430                  return;
   431  
   432          spin_lock(&c->journal.flush_write_lock);
   433          if (c->journal.btree_flushing) {
   434                  spin_unlock(&c->journal.flush_write_lock);
   435                  return;
   436          }
   437          c->journal.btree_flushing = true;
   438          spin_unlock(&c->journal.flush_write_lock);
   439  
   440          /* get the oldest journal entry and check its refcount */
   441          spin_lock(&c->journal.lock);
   442          fifo_front_p = &fifo_front(&c->journal.pin);
   443          ref_nr = atomic_read(fifo_front_p);
   444          if (ref_nr <= 0) {
                    ^^^^^^^^^^^
Unsigned can't be less than zero.

   445                  /*
   446                   * do nothing if no btree node references
   447                   * the oldest journal entry
   448                   */
   449                  spin_unlock(&c->journal.lock);
   450                  goto out;
   451          }
   452          spin_unlock(&c->journal.lock);

regards,
dan carpenter
