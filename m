From: Rui Hua <huarui.dev@gmail.com>
Subject: Re: [bug report] bcache stucked when writting jounrnal
Date: Wed, 22 Nov 2017 18:21:53 +0800
Message-ID: <CAPGwLLO9LaDo-34A67A-o0Eh2TUUfarvarB=zPwm8Yhb1gTJbA@mail.gmail.com>
References: <1511340585-24848-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1511340585-24848-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>, linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi, Junhui,

I have met the similar problem once.
It looks like a deadlock between the cache device register thread and
bcache_allocator thread.

The trace info tell us the journal is full, probablely the allocator
thread waits on bch_prio_write()->prio_io()->bch_journal_meta(), but
there is no RESERVE_BTREE buckets to use for journal replay at this
time, so register thread waits on
bch_journal_replay()->bch_btree_insert()

The path which your register command possibly blocked:
run_cache_set()
  -> bch_journal_replay()
      -> bch_btree_insert()
          -> btree_insert_fn()
              -> bch_btree_insert_node()
                  -> btree_split()
                      -> btree_check_reserve() ----here we find
RESERVE_BTREE buckets is empty, and then schedule out...

bch_allocator_thread()
  ->bch_prio_write()
     ->bch_journal_meta()


You can apply this patch to your code and try to register again. This
is for your reference only. Because this patch was not verified in my
environment, because my env was damaged last time before I dig into
code and write this patch, I hopefully it can resolve your problem:-)


Signed-off-by: Hua Rui <huarui.dev@gmail.com>
---
 drivers/md/bcache/btree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 11c5503..211be35 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1868,14 +1868,16 @@ void bch_initial_gc_finish(struct cache_set *c)
         */
        for_each_cache(ca, c, i) {
                for_each_bucket(b, ca) {
-                       if (fifo_full(&ca->free[RESERVE_PRIO]))
+                       if (fifo_full(&ca->free[RESERVE_PRIO]) &&
+                           fifo_full(&ca->free[RESERVE_BTREE]))
                                break;

                        if (bch_can_invalidate_bucket(ca, b) &&
                            !GC_MARK(b)) {
                                __bch_invalidate_one_bucket(ca, b);
-                               fifo_push(&ca->free[RESERVE_PRIO],
-                                         b - ca->buckets);
+                               if
(!fifo_push(&ca->free[RESERVE_PRIO], b - ca->buckets))
+                                       fifo_push(&ca->free[RESERVE_BTREE],
+                                               b - ca->buckets);
                        }
                }
        }
-- 
1.8.3.1

2017-11-22 16:49 GMT+08:00  <tang.junhui@zte.com.cn>:
> From: Tang Junhui <tang.junhui@zte.com.cn>
>
> Hi, everyone:
>
> bcache stucked when reboot system after high load.
>
> root      1704  3.7  0.0   4164   360 ?        D    14:07   0:09 /usr/lib/udev/bcache-register /dev/sdc
> [<ffffffffa062d2f5>] closure_sync+0x25/0x90 [bcache]
> [<ffffffffa062b481>] bch_btree_set_root+0x1f1/0x250 [bcache]
> [<ffffffffa062bcf2>] btree_split+0x632/0x760 [bcache]
> [<ffffffffa062c1fb>] bch_btree_insert_recurse+0x3db/0x500 [bcache]
> [<ffffffffa062c487>] bch_btree_insert+0x167/0x360 [bcache]
> [<ffffffffa062feba>] bch_journal_replay+0x1aa/0x2e0 [bcache]
> [<ffffffffa0642b36>] run_cache_set+0x813/0x83e [bcache]
> [<ffffffffa063aee3>] register_bcache+0xea3/0x1410 [bcache]
> [<ffffffff812e453f>] kobj_attr_store+0xf/0x20
> [<ffffffff81246be6>] sysfs_write_file+0xc6/0x140
> [<ffffffff811cdbfd>] vfs_write+0xbd/0x1e0
> [<ffffffff811ce648>] SyS_write+0x58/0xb0
> [<ffffffff816306c9>] system_call_fastpath+0x16/0x1b
>
> root      2097  0.0  0.0      0     0 ?        D    14:08   0:00 [bcache_allocato]
> [<ffffffffa062d2f5>] closure_sync+0x25/0x90 [bcache]
> [<ffffffffa06387fe>] bch_prio_write+0x23e/0x340 [bcache]
> [<ffffffffa0620e50>] bch_allocator_thread+0x340/0x350 [bcache]
> [<ffffffff810990bf>] kthread+0xcf/0xe0
> [<ffffffff81630618>] ret_from_fork+0x58/0x90
>
> I try to add some debug info to the code, it seems that it always run in
> journal_write_unlocked()
>         else if (journal_full(&c->journal)) {
>                 journal_reclaim(c);
>                 spin_unlock(&c->journal.lock);
>
>                 btree_flush_write(c);
>                 continue_at(cl, journal_write, system_wq);
>                 return;
>         }
> the condition of journal_full() always returns true, so the journal
> can not finish all the time.
>
> My code has a little difference with the upstream branch.
> Could anyone give me some suggestions?
>
> Thanks,
> Tang
>
>
