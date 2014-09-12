From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: bcache_gc: BUG: soft lockup - CPU#4 stuck for 22s!
Date: Fri, 12 Sep 2014 20:09:17 +0200
Message-ID: <541336CD.9030709@profihost.ag>
References: <54127040.7090309@profihost.ag> <54133293.3000901@dsotm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:38042 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaILSJS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 12 Sep 2014 14:09:18 -0400
In-Reply-To: <54133293.3000901@dsotm.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ross Anderson <rosander@dsotm.net>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi Ross,
Am 12.09.2014 19:51, schrieb Ross Anderson:
> Greetings,
>
> This was supposed to be corrected in the 3.17 push. I haven't seen it on
> my systems over the past few weeks of testing. Can you provide more
> details what was running when this occurred? What FS, hardware etc.

I'm sorry i was using a 3.16.2 kernel but with all bcache patches from 
3.17-rc4 added - my fault.

Which one should fix this?

List:
commit 4f6ce97baa7cf98afbd1962a2a184b9c05775e61
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Mon Jul 7 13:03:36 2014 -0700

     bcache: Drop unneeded blk_sync_queue() calls

     this is needed for the queue/block device we created (it's done by
     blk_cleanup_queue() which we do call) - but calling it for the 
block devices we
     only opened is pointless.

     Change-Id: I53dfded14ed15b9581d10ca8399d5e1b3abbf9f2
     (cherry picked from commit 0781c8748cf1ea2b0dcd966571103909528c4efa)

commit 486b2c0d5254fa541634116cf9427089aca92105
Author: Jianjian Huo <samuel.huo@gmail.com>
Date:   Sun Jul 13 09:08:59 2014 -0700

     bcache: add mutex lock for bch_is_open

     Since bch_is_open will iterate linked list bch_cache_sets and
     uncached_devices, it needs bch_register_lock.

     Signed-off-by: Jianjian Huo <samuel.huo@gmail.com>
     (cherry picked from commit 789d21dbd9d8889e62c79ec19585fcc97e42ef07)

commit 3b126259ee5ace5d3df27e7af1f5b623f091e9aa
Author: Surbhi Palande <sap@daterainc.com>
Date:   Thu Apr 17 12:07:04 2014 -0700

     bcache: Correct printing of btree_gc_max_duration_ms

     time_stats::btree_gc_max_duration_mc is not bit shifted by 8

     Fixes BUG #138

     Change-Id: I44fc6e1d0579674016acc533f1a546b080e5371a
     Signed-off-by: Surbhi Palande <sap@daterainc.com>
     (cherry picked from commit 5b25abade29616d42d60f9bd5e6a5ad07f7314e3)

commit e2c7fe1094ec597b5290f7b7030368ad303b66a5
Author: Slava Pestov <sp@daterainc.com>
Date:   Sat Jul 12 00:22:53 2014 -0700

     bcache: try to set b->parent properly

     bcache_flash_dev.ktest would reliably crash with 8k and 16k bucket size
     before; now it passes.

     Change-Id: Ib542232235e39298c3a7548fe52b645cabb823d1
     (cherry picked from commit 2452cc89063a2a6890368f185c4b6d7d8802179e)

commit 827381306e94ba3e2d18b8bf5eabb07cd99bbeb6
Author: Slava Pestov <sp@daterainc.com>
Date:   Thu Jun 19 15:05:59 2014 -0700

     bcache: fix memory corruption in init error path

     If register_cache_set() failed, we would touch ca->set after
     it had already been freed. Also, fix an assertion to catch
     this.

     Change-Id: I748e5f5b223e2d9b2602075dec2f997cced2394d
     (cherry picked from commit c9a78332b42cbdcdd386a95192a716b67d1711a4)

commit e53833bb678f9a02888c2b51789ed3c679bb72c7
Author: Slava Pestov <sp@daterainc.com>
Date:   Fri Jul 11 12:17:41 2014 -0700

     bcache: fix crash with incomplete cache set

     Change-Id: I6abde52afe917633480caaf4e2518f42a816d886
     (cherry picked from commit bf0c55c986540483c34ca640f2eef4c3314388b1)

commit c917ccd4c371082117ef09b6e1dd95b98db34359
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Wed Jun 11 19:44:49 2014 -0700

     bcache: Fix more early shutdown bugs

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit d83353b319d47ef8cce82467da6a25c2d558253f)

commit 5a95fa33c0652c4ec8e354284e432a8f5f89b2ff
Author: Slava Pestov <sp@daterainc.com>
Date:   Sat Jul 12 21:53:11 2014 -0700

     bcache: fix use-after-free in btree_gc_coalesce()

     If we goto out_nocoalesce after we free new_nodes[0], we end up freeing
     new_nodes[0] again. This was generating a lockdep warning. The fix is
     to set new_nodes[0] to NULL, since the out_nocoalesce path safely
     ignores NULL entries in the new_nodes array.

     This regression was introduced in 2d7f9531.

     Change-Id: I76564d7257800583214376b4bacf236cda90c89c
     (cherry picked from commit 400ffaa2acd72274e2c7293a9724382383bebf3e)

commit 21690f2df19df170a8ebdb8bc53123529e74bbba
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Mon Jun 2 15:39:44 2014 -0700

     bcache: Fix an infinite loop in journal replay

     When running with multiple cache devices, if one of the devices has 
a completely
     empty journal but we'd already found some journal entries on a 
previosu device
     we'd go into an infinite loop.

     Change-Id: I1dcdc0d738192746de28f40e8b08825b0dea5e2b
     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit 6b708de64adb6dc8319e7aeac922b46904fbeeec)

commit 7559a9aa48ca73972f8f68f61735828cc6407e43
Author: Slava Pestov <sp@daterainc.com>
Date:   Fri May 23 11:18:35 2014 -0700

     bcache: fix crash in bcache_btree_node_alloc_fail tracepoint

     'b' was NULL.

     Change-Id: Icac0fd04afa2d23f213d96d51afd53374e6dd0c0
     (cherry picked from commit 913dc33fb2720fb5f979011664294137ddd8b13b)

commit cc6b3ec3da3fb190d10f8310f182200e1cf29efc
Author: Slava Pestov <sp@daterainc.com>
Date:   Thu May 22 12:14:24 2014 -0700

     bcache: bcache_write tracepoint was crashing

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit 60ae81eee86dd7a520db8c1e3d702b49fc0418b5)

commit bdcf832c86e3833d85a021129eefc9e2f4780cea
Author: Slava Pestov <sp@daterainc.com>
Date:   Mon Jun 30 22:31:20 2014 -0700

     bcache: fix typo in bch_bkey_equal_header

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit 8e0948080670f6330229718b15a6a1a011d441ce)

commit 8265043558c66f53c3032f30f5c764b716504daa
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Mon May 19 08:55:40 2014 -0700

     bcache: Allocate bounce buffers with GFP_NOWAIT

     There's no point in blocking on these allocations, since our 
fallback paths will
     probably go faster than blocking.

     Change-Id: I733ca202c25cb36bde02607a0a60552229a4241c
     (cherry picked from commit 501d52a90cbe652b41336c206ff0e95799d5a9b5)

commit b2c9961d6120c0993c06843484ee7f8c7cf7e39a
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Mon May 19 08:57:55 2014 -0700

     bcache: Make sure to pass GFP_WAIT to mempool_alloc()

     this was very wrong - mempool_alloc() only guarantees success with 
GFP_WAIT.
     bcache uses GFP_NOWAIT in various other places where we have a 
fallback,
     circuits must've gotten crossed when writing this code or something.

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit bcf090e0040e30f8409e6a535a01e6473afb096f)

commit 64786bb5585b84f41892c2df052c963b1a06ec80
Author: Slava Pestov <sp@daterainc.com>
Date:   Thu May 1 13:48:57 2014 -0700

     bcache: fix uninterruptible sleep in writeback thread

     There were two issues here:

     - writeback thread did not start until the device first became dirty
     - writeback thread used uninterruptible sleep once running

     Without this patch I see kernel warnings printed and a load average of
     1.52 after booting my test VM. With this patch the warnings are 
gone and
     the load average is near 0.00 as expected.

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit 9e5c353510b26500bd6b8309823ac9ef2837b761)

commit cc58857bb12c78b81f81ad838e9005d6c47b8afe
Author: Slava Pestov <sp@daterainc.com>
Date:   Mon Apr 21 18:23:12 2014 -0700

     bcache: wait for buckets when allocating new btree root

     Tested:
     - sometimes bcache_tier test would hang on startup with a failure
       to allocate the btree root -- no longer seeing this

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit c5aa4a3157b55bdca18dd2a9d9f43314470b6d32)

commit ed0487836568d152ef4d1f9a16de9aa5872e6c70
Author: Slava Pestov <sp@daterainc.com>
Date:   Tue May 20 12:20:28 2014 -0700

     bcache: fix crash on shutdown in passthrough mode

     We never started the writeback thread in this case, so don't stop it.
     (cherry picked from commit a664d0f05a2ec02c8f042db536d84d15d6e19e81)

commit 052aefa2ce3455c0654591e43d90fb46a2336f8c
Author: Slava Pestov <sp@daterainc.com>
Date:   Tue Apr 29 15:39:27 2014 -0700

     bcache: fix lockdep warnings on shutdown
     (cherry picked from commit e5112201c1285841f8b565ece5d6ae7e0d7947a2)

commit b1a3f91107bbd5e22e9f461dd70f210f15393108
Author: Slava Pestov <sp@daterainc.com>
Date:   Mon Apr 21 18:22:35 2014 -0700

     bcache allocator: send discards with correct size
     (cherry picked from commit 8b326d3a2a76912dfed2f0ab937d59fae9512ca2)

commit 35c5161eb523784bff426f678d387545f0fa4f45
Author: Surbhi Palande <sap@daterainc.com>
Date:   Thu Apr 10 16:09:51 2014 -0700

     bcache: Fix to remove the rcu_sched stalls.

     while loop was executing infinitely.
     This fix ends the while loop gracefully.

     Signed-off-by: Surbhi Palande <sap@daterainc.com>
     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit dbd810ab678d262d3772d29b65844d7b20dc47bc)

commit 0b119e88f5e5400018a9f5edba6c85d1431701bd
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Thu Apr 10 17:58:49 2014 -0700

     bcache: Fix a journal replay bug

     journal replay wansn't validating pointers with 
bch_extent_invalid() before
     derefing, fixed

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit 9aa61a992acceeec0d1de2cd99938421498659d5)

commit ffccebead362a0d5f236bc7d18642b85f1fe41b1
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Wed Mar 19 17:49:37 2014 -0700

     bcache: Fix a bug when detaching

     After detaching a backing device from a cache set, a bit wasn't getting
     reset meaning the second detach wouldn't work correctly.

     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
     (cherry picked from commit 5b1016e62f74c53e0330403025954c8d95384c03)

Stefan


> Ross Anderson
>
> On 9/11/2014 11:02 PM, Stefan Priebe wrote:
>> Hi,
>>
>> while trying to use bcache on 3.17-rc4 i got those messages and a load
>> of 1000.
>>
>> Is this a known problem?
>>
>> 14-09-12 02:32:22     BUG: soft lockup - CPU#4 stuck for 23s!
>> [bcache_gc:1585]
>> 2014-09-12 02:31:54     INFO: rcu_sched self-detected stall on CPU {
>> 4} (t=150009 jiffies g=1762124 c=1762123 q=235323)
>> 2014-09-12 02:31:42     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:31:14     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:30:46     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:30:18     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:29:50     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:29:22     BUG: soft lockup - CPU#4 stuck for 23s!
>> [bcache_gc:1585]
>> 2014-09-12 02:28:54     INFO: rcu_sched self-detected stall on CPU {
>> 4} (t=105006 jiffies g=1762124 c=1762123 q=209365)
>> 2014-09-12 02:28:42     BUG: soft lockup - CPU#4 stuck for 23s!
>> [bcache_gc:1585]
>> 2014-09-12 02:28:14     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:27:46     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:27:18     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:26:50     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:26:22     BUG: soft lockup - CPU#4 stuck for 22s!
>> [bcache_gc:1585]
>> 2014-09-12 02:25:54     INFO: rcu_sched self-detected stall on CPU {
>> 4} (t=60003 jiffies g=1762124 c=1762123 q=136221)
>> 2014-09-12 02:25:42     BUG: soft lockup - CPU#4 stuck for 23s!
>> [bcache_gc:1585]
>> 2014-09-12 02:25:14     BUG: soft lockup - CPU#4 stuck for 23s!
>> [bcache_gc:1585]
>> 2014-09-12 02:24:46     BUG: soft lockup - CPU#4 stuck for 23s!
>> [bcache_gc:1585]
>>
>>
>> Stefan
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
