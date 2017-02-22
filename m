From: shiva rkreddy <shiva.rkreddy@gmail.com>
Subject: Re: Drop in Iops with fsync when using NVMe as cache
Date: Wed, 22 Feb 2017 09:47:40 -0600
Message-ID: <CAPntomDbChdaEeJ+6E4-La-fEYgsbrKd1wUcxgM1mVKtTtinAA@mail.gmail.com>
References: <CAPntomBf8c6TFBLM5iBuX=OWmfQ-uGCUiDdJnXEn1+-gS7KJaw@mail.gmail.com>
 <20170222094057.GD31967@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34517 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932462AbdBVPrm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Feb 2017 10:47:42 -0500
Received: by mail-yw0-f180.google.com with SMTP id p77so3260737ywg.1
        for <linux-bcache@vger.kernel.org>; Wed, 22 Feb 2017 07:47:41 -0800 (PST)
In-Reply-To: <20170222094057.GD31967@suse.cz>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

I've tried fio directly on nvme device and without filesystem. The
drop with fsync is not that significant; 44313 vs 42713 on a 30s
randwrite run with iodepth=1


# fio -filename=/dev/nvme0n1 -direct=1 -ioengine=libaio -rw=randwrite
-bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.1.3
Starting 1 process
Jobs: 1 (f=1): [w] [100.0% done] [0KB/177.6MB/0KB /s] [0/45.5K/0 iops]
[eta 00m:00s]
mytest: (groupid=0, jobs=1): err= 0: pid=2131: Thu Feb  9 18:56:01 2017
  write: io=5193.2MB, bw=177253KB/s, iops=44313, runt= 30001msec

# fio -filename=/dev/nvme0n1 -direct=1 -ioengine=libaio -rw=randwrite
-bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based -fsync=1
mytest: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.1.3
Starting 1 process
Jobs: 1 (f=1): [w] [100.0% done] [0KB/167.4MB/0KB /s] [0/42.9K/0 iops]
[eta 00m:00s]
mytest: (groupid=0, jobs=1): err= 0: pid=2136: Thu Feb  9 19:04:54 2017
  write: io=5005.5MB, bw=170853KB/s, iops=42713, runt= 30000msec


On Wed, Feb 22, 2017 at 3:40 AM, Vojtech Pavlik <vojtech@suse.com> wrote:
> On Tue, Feb 21, 2017 at 10:48:06AM -0600, shiva rkreddy wrote:
>
>> fio command without fsync:
>>
>> # fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
>> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based
>>
>> iops : 35k
>>
>> fio command with fsync:
>>
>> fio -filename=/dev/bcache0 -direct=1 -ioengine=libaio -rw=randwrite
>> -bs=4k -name=mytest -iodepth=1 -runtime=30 -time_based -fsync=1
>>
>> iops: 8.1k
>
>> I'm quite surprised by the drop in iops with fsync turned on. Is this
>> expected or am I missing some basic setting?
>
> It's not uncommon that fsync would have a huge performance impact.
> Without fsync, most of the data never hits the storage and is only
> staying in the system memory.
>
> May I suggest that you try to measure the performance of the same tests
> when the filesystem is created on the NVMe device directly, without
> using bcache? You're likely to observe a similar pattern.
>
> --
> Vojtech Pavlik
> Director SUSE Labs
