From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: Testing tiering: a little scary message "IO error" ; I can't
 unregister tier device
Date: Fri, 26 Aug 2016 10:01:34 +0200
Message-ID: <a84b971d-9b39-165e-84b8-79d360c10822@mejor.pl>
References: <d6c6187a-497c-043e-29ff-a1d47eb2c456@mejor.pl>
 <20160826022615.qqfsbpwfs3p5utud@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:54141 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751168AbcHZIF6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Aug 2016 04:05:58 -0400
In-Reply-To: <20160826022615.qqfsbpwfs3p5utud@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

W dniu 26.08.2016 o 04:26, Kent Overstreet pisze:
> On Thu, Aug 25, 2016 at 12:13:53PM +0200, Marcin Mirosław wrote:
>> Hi!
>>
>> 1.
>> # ./bcache format --compression_type=lz4 --error_action=readonly
>> --tier=0 /dev/system10/bcache --tier=1 /dev/sdd1
>> /dev/system10/bcache contains a bcache filesystem
>> Proceed anyway? (y,n) y
>> /dev/sdd1 contains a bcache filesystem
>> Proceed anyway? (y,n) y
>> UUID:                   ab597c6a-7394-41ff-9138-e66c5722bc9d
>> Set UUID:               311a03a9-3646-40a8-935f-10030ee75b25
>> version:                6
>> nbuckets:               22288
>> block_size:             1
>> bucket_size:            1024
>> nr_in_set:              2
>> nr_this_dev:            0
>> first_bucket:           3
>> UUID:                   2ac11eef-6d66-4ca0-bd6e-17ac83c6942a
>> Set UUID:               311a03a9-3646-40a8-935f-10030ee75b25
>> version:                6
>> nbuckets:               40960
>> block_size:             1
>> bucket_size:            1024
>> nr_in_set:              2
>> nr_this_dev:            1
>> first_bucket:           3
>>
>>
>> # mount -o noatime -t bcache /dev/system10/bcache:/dev/sdd1 /mnt/test
>> # dd if=/dev/urandom of=/mnt/test/randomdata bs=1M count=1000
>> # md5sum /mnt/test/randomdata
>> a7d2712c673d891d9ba50f2f7157c091  /mnt/test/randomdata
>> # cat  /sys/fs/bcache/311a03a9-3646-40a8-935f-10030ee75b25/tiering_percent
>> 10
>> # echo 1 >
>> /sys/fs/bcache/311a03a9-3646-40a8-935f-10030ee75b25/tiering_percent ;
>> sleep 5 ; umount /mnt/test
>>
>> Now I'm getting in dmesg:
>> Aug 25 11:55:04 localhost kernel: [ 1366.385581] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): IO error: read only
>> Aug 25 11:55:04 localhost kernel: [ 1366.385600] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): IO error: read only
>> Aug 25 11:55:04 localhost kernel: [ 1366.390298] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): IO error: read only
>> Aug 25 11:55:04 localhost kernel: [ 1366.391076] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): IO error: read only
>> Aug 25 11:55:04 localhost kernel: [ 1366.391098] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): IO error: read only
>> Aug 25 11:55:04 localhost kernel: [ 1366.391111] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): IO error: read only
>> Aug 25 11:55:04 localhost kernel: [ 1366.417244] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): IO error: read only
>> Aug 25 11:55:04 localhost kernel: [ 1366.656319] bcache
>> (311a03a9-3646-40a8-935f-10030ee75b25): stopped
>>
>> Now:
>> # mount -o noatime -t bcache /dev/system10/bcache:/dev/sdd1 /mnt/test
>> # md5sum /mnt/test/randomdata
>> a7d2712c673d891d9ba50f2f7157c091  /mnt/test/randomdata
>>
>> So it is ok. But logs in dmesg are a little scary.
>> I had data corruption in similar situation like this but I can't
>> reproduce it.
>> Btw, should be bcachefs immune of power reset while IO activity?
> 
> Yes, it definitely should be.
> 
> Do id you see in the log what caused it to go RO? Or did you do that via sysfs?

I changed state via sysfs only.


>>
>> 2. Unsuccessful try of unregister device:
>> # echo 1 >
>> /sys/fs/bcache/311a03a9-3646-40a8-935f-10030ee75b25/cache1/unregister
>>
>> and console hangs. I have acces to files from other console.
>> In dmesg is:
>> Aug 25 12:07:48 localhost kernel: [ 2130.432099] INFO: task bash:19379
>> blocked for more than 30 seconds.
>> Aug 25 12:07:48 localhost kernel: [ 2130.432105]       Tainted: P
>>    O    4.7.0-bcache+ #5
>> Aug 25 12:07:48 localhost kernel: [ 2130.432108] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Aug 25 12:07:48 localhost kernel: [ 2130.432111] bash            D
>> ffff88014857bc88     0 19379  19376 0x00000000
>> Aug 25 12:07:48 localhost kernel: [ 2130.432118]  ffff88014857bc88
>> 0000000000000000 ffff88014a1a1b40 ffff8800c8f78000
>> Aug 25 12:07:48 localhost kernel: [ 2130.432124]  ffff88014857bcb0
>> ffff88014857c000 ffffffffc0785244 ffff8800c8f78000
>> Aug 25 12:07:48 localhost kernel: [ 2130.432129]  00000000ffffffff
>> ffffffffc0785248 ffff88014857bca0 ffffffff8156fcea
>> Aug 25 12:07:48 localhost kernel: [ 2130.432135] Call Trace:
>> Aug 25 12:07:48 localhost kernel: [ 2130.432147]  [<ffffffff8156fcea>]
>> schedule+0x3a/0x90
>> Aug 25 12:07:48 localhost kernel: [ 2130.432152]  [<ffffffff81570163>]
>> schedule_preempt_disabled+0x13/0x20
>> Aug 25 12:07:48 localhost kernel: [ 2130.432155]  [<ffffffff81571c3b>]
>> __mutex_lock_slowpath+0x9b/0x140
>> Aug 25 12:07:48 localhost kernel: [ 2130.432159]  [<ffffffff81571cf2>]
>> mutex_lock+0x12/0x30
>> Aug 25 12:07:48 localhost kernel: [ 2130.432202]  [<ffffffffc075f8be>]
>> bch_cache_remove+0x1e/0xe0 [bcache]
>> Aug 25 12:07:48 localhost kernel: [ 2130.432218]  [<ffffffffc0762605>]
>> __bch_cache_store+0x245/0x650 [bcache]
>> Aug 25 12:07:48 localhost kernel: [ 2130.432234]  [<ffffffffc0762a44>]
>> bch_cache_store+0x34/0x50 [bcache]
>> Aug 25 12:07:48 localhost kernel: [ 2130.432238]  [<ffffffff81206272>]
>> sysfs_kf_write+0x32/0x40
>> Aug 25 12:07:48 localhost kernel: [ 2130.432240]  [<ffffffff812057f3>]
>> kernfs_fop_write+0x113/0x190
>> Aug 25 12:07:48 localhost kernel: [ 2130.432243]  [<ffffffff8118e5c2>]
>> __vfs_write+0x32/0x150
>> Aug 25 12:07:48 localhost kernel: [ 2130.432247]  [<ffffffff812e8a33>] ?
>> __this_cpu_preempt_check+0x13/0x20
>> Aug 25 12:07:48 localhost kernel: [ 2130.432251]  [<ffffffff8109f201>] ?
>> update_fast_ctr+0x41/0x70
>> Aug 25 12:07:48 localhost kernel: [ 2130.432253]  [<ffffffff8109f262>] ?
>> percpu_down_read+0x12/0x50
>> Aug 25 12:07:48 localhost kernel: [ 2130.432256]  [<ffffffff8118f8c3>]
>> vfs_write+0xb3/0x1b0
>> Aug 25 12:07:48 localhost kernel: [ 2130.432258]  [<ffffffff81190ce0>]
>> SyS_write+0x50/0xc0
>> Aug 25 12:07:48 localhost kernel: [ 2130.432261]  [<ffffffff811adbde>] ?
>> __close_fd+0x9e/0xc0
>> Aug 25 12:07:48 localhost kernel: [ 2130.432264]  [<ffffffff8157431f>]
>> entry_SYSCALL_64_fastpath+0x17/0x93
>>
>>
>>
>> iostat show:
>> # iostat -d 1 3 /dev/sdd1 /dev/mapper/system10-bcache
>> Linux 4.7.0-bcache+ (marcinm)   25.08.2016      _x86_64_        (4 CPU)
>>
>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>> sdd1              0,90         2,40        56,36       5920     138772
>> dm-14            21,32       919,34       423,55    2263587    1042859
>>
>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>> sdd1              1,00         0,00        64,00          0         64
>> dm-14             2,00        64,00         0,50         64          0
>>
>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>> sdd1              1,00         0,00        64,00          0         64
>> dm-14             2,00        64,00         0,50         64          0
>
