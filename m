From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs][tier]  INFO: task bch_tier_read:21414 blocked for
 more than 120 seconds.
Date: Tue, 11 Oct 2016 17:26:00 -0800
Message-ID: <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
References: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34898 "EHLO
        mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbcJLB0V (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Oct 2016 21:26:21 -0400
Received: by mail-pa0-f47.google.com with SMTP id qn10so22902561pac.2
        for <linux-bcache@vger.kernel.org>; Tue, 11 Oct 2016 18:26:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Oct 11, 2016 at 11:13:56PM +0200, Marcin wrote:
> Hi!
> 
> Kernel at:
> commit 2677d7d38f465ca9c8c33619a46bf4fe2852c39d
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Mon Oct 10 12:10:48 2016 -0800
> 
> Freshly formated two tiered filesystem:
> # bcache format --force --tier 0 /dev/sde1 --tier 1 /dev/sdd1
> --btree_node=262144
> External UUID:                  f213abd2-2517-4723-a82f-cffed89094f6
> Internal UUID:                  b6b5409e-e198-43a6-8e2a-49f4ba8c714b
> Label:
> Version:                        6
> Block_size:                     512
> Btree node size:                256.0K
> Error action:                   readonly
> Clean:                          0
> Metadata replicas:              have 1, want 1
> Data replicas:                  have 1, want 1
> Metadata checksum type:         crc32c
> Data checksum type:             crc32c
> Compression type:               none
> String hash type:               siphash
> 32 bit inodes:                  0
> GC reserve percentage:          0%
> Root reserve percentage:        0%
> Devices:                        2
> 
> Device 0:
>   UUID:                         29916bec-62ce-4d1e-bf3f-d2b72b1e68b2
>   bucket_size:                  128.0K
>   first_bucket:                 8
>   nbuckets:                     81920
>   Last mount:                   (never)
>   State:                        active
>   Tier:                         0
>   Has metadata:                 0
>   Has data:                     0
>   Replacement policy:           lru
>   Discard:                      0
> 
> Device 1:
>   UUID:                         84a22c92-c386-42a7-a98d-a4f00e916527
>   bucket_size:                  256.0K
>   first_bucket:                 4
>   nbuckets:                     5723193
>   Last mount:                   (never)
>   State:                        active
>   Tier:                         1
> [I've got no more in tmux history]
> 
> 
> While I was copying many small files using mc I got:
> [ 6019.040067] INFO: task bch_tier_read:21414 blocked for more than 120
> seconds.
> [ 6019.040071]       Tainted: G        W       4.8.0+ #1
> [ 6019.040072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 6019.040073] bch_tier_read   D ffff880003a7bbc0     0 21414      2
> 0x00000000
> [ 6019.040079]  ffff880003a7bbc0 ffff880036949a80 ffff880000f64f80
> ffff880003a7bc98
> [ 6019.040082]  ffff880003a7c000 ffff880003a7bd08 ffff880003a7bcf0
> ffff880003a7bc00
> [ 6019.040085]  0000000000000001 ffff880003a7bbd8 ffffffff81473730
> ffff880003a7bc98
> [ 6019.040089] Call Trace:
> [ 6019.040096]  [<ffffffff81473730>] schedule+0x30/0x80
> [ 6019.040128]  [<ffffffffa02c7798>] bch_move_ctxt_wait+0x88/0xb0 [bcache]
> [ 6019.040133]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
> [ 6019.040152]  [<ffffffffa02d5b53>] read_tiering+0x143/0x4c0 [bcache]
> [ 6019.040155]  [<ffffffff814732ad>] ? __schedule+0x2cd/0x720
> [ 6019.040172]  [<ffffffffa02a959a>] ?
> bch_bucket_stats_read_cache+0xda/0x150 [bcache]
> [ 6019.040191]  [<ffffffffa02d6117>] bch_tiering_thread+0x247/0x250 [bcache]
> [ 6019.040210]  [<ffffffffa02d5ed0>] ? read_tiering+0x4c0/0x4c0 [bcache]
> [ 6019.040213]  [<ffffffff81069f84>] kthread+0xc4/0xe0
> [ 6019.040216]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
> [ 6019.040219]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160

You're not the only one who's seeing this, I've been chasing this bug for the
past several days...
