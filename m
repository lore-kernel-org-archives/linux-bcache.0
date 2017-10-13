From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache failure hangs something in kernel
Date: Fri, 13 Oct 2017 01:11:41 -0700
Message-ID: <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
 <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:47035 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbdJMILo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 04:11:44 -0400
Received: by mail-pf0-f175.google.com with SMTP id p87so9010174pfj.3
        for <linux-bcache@vger.kernel.org>; Fri, 13 Oct 2017 01:11:44 -0700 (PDT)
In-Reply-To: <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

On 10/13/2017 12:59 AM, Alexandr Kuznetsov wrote:
> Hi
> 
>> It looks like probably the superblock of md0p2 and other data structures
>> were corrupted during the lvm commands, and in turn this is triggering
>> bugs with bcache (bcache should detect the situation and abort
>> everything, but instead is left with the bucket_lock held and freezes).
> This immediately rises questions about reliability and safety of lvm and
> bcache.

Neither is safe if you overwrite the superblock with an errant command.
If you pvcreate'd on the backing device directly, or did something
similarly, that would be expected to go badly.

> I thought that lvm is old, mature and safe technology, but here it is
> stuck, then manualy interrupted and result is catastrophic data corruption.
> lvm sits on top of that sandwich of block devices, on layer of
> /dev/bcache* devices. Another question here is how crazy lvm could
> damage data outside of /dev/bcache* devices? This means that some
> necessary io buffer range checks are missing inside bcache.

I don't know what commands you ran.  I've never seen/heard of a bcache
superblock corrupted, and I believe the mappings/shrink are appropriate.

> Unfortunately this md0p* block devices are not separate from each other
> - there is one 2Tb volume on top of them inside lvm. Loss of one 100Gib
> part and dirty data in another 100Gib part can kill entire file system
> with very high probability. Yesterday I have read that bcache failures
> are nasty, because file system roots data often resides on cache and is
> dirty on backing device.> Is there any tool like fsck exist, that can check and may be try to
> recover data from caching and backing devices? Or developers can get
> this corrupted images to experiment for bugfixing?
Sorry, no.  Other filesystems / block devices will not behave well if
you overwrite their superblock, either.  This is not behavior bcache is
expected to recover gracefully from (though it shouldn't hang).

re: the dirty data in the 100GB part, having a filesystem with a
superblock marked dirty is fine if the cache device is available.

Mike

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
