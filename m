From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
 aka ageing filesystem
Date: Tue, 18 Oct 2016 15:13:26 +0200
Message-ID: <92700c16-cbbb-6954-666d-cb09805d5a82@mejor.pl>
References: <20161018130409.2elmg32ojy7jgwki@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:60994 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755217AbcJRNNg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Oct 2016 09:13:36 -0400
In-Reply-To: <20161018130409.2elmg32ojy7jgwki@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 18.10.2016 o 15:04, Kent Overstreet pisze:
> On Tue, Oct 18, 2016 at 02:51:11PM +0200, Marcin Mirosław wrote:
>> W dniu 18.10.2016 o 14:45, Kent Overstreet pisze:
>>> The issue is that right now btree node coalescing is only run as a batch pass
>>> when mark and sweep GC runs (it has nothing to do with GC, it just runs at the
>>> same time in the current code). At some point we need to come up with a good way
>>> of triggering it as needed.
>>>
>>> Try triggering a gc, and then check mount time:
>>>
>>> echo 1 > /sys/fs/bcache/<uuid>/internal/trigger_gc
>>
>> No change:
>> [ 8417.101640] bcache (dm-12): starting mark and sweep:
>> [ 8433.795575] bcache (dm-12): mark and sweep done
>> [ 8433.795842] bcache (dm-12): starting journal replay:
>> [ 8433.796064] bcache (dm-12): journal replay done, 129 keys in 90
>> entries, seq 28581
>> [ 8433.796075] bcache (dm-12): journal replay done
>> [ 8433.796076] bcache (dm-12): starting fs gc:
>> [ 8433.799493] bcache (dm-12): fs gc done
>> [ 8433.799495] bcache (dm-12): starting fsck:
>> [ 8433.800613] bcache (dm-12): fsck done
>>
>>
>> /dev/mapper/system10-bcache  9,8G  421M  9,4G   5% /mnt/test
> 
> Bleh.
> 
> Can you check how many nodes are in each btree, post coalescing?
> 
> grep -c ^l /sys/kernel/debug/bcache/<uuid>/*-formats
> 
> Coalescing will also just skip running if the allocator doesn't have enough new
> nodes ready to go, rather than block on the allocator thread with locks held -
> you can try running it a few times, and see if it's making any progress
> shrinking the btrees.

No change after a few run, I've got constant values:
/sys/kernel/debug/bcache/61fc20db-d626-4f0d-bb33-31a4d998f6df/dirents-formats:1044
/sys/kernel/debug/bcache/61fc20db-d626-4f0d-bb33-31a4d998f6df/extents-formats:1
/sys/kernel/debug/bcache/61fc20db-d626-4f0d-bb33-31a4d998f6df/inodes-formats:2320
/sys/kernel/debug/bcache/61fc20db-d626-4f0d-bb33-31a4d998f6df/xattrs-formats:1
