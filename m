From: Alexandr Kuznetsov <progmachine@xenlab.one>
Subject: Re: bcache failure hangs something in kernel
Date: Fri, 13 Oct 2017 12:10:25 +0300
Message-ID: <f9afc17d-de8b-1d5e-bb34-260051aa2de1@xenlab.one>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
 <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
 <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from forward104j.mail.yandex.net ([5.45.198.247]:37430 "EHLO
        forward104j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751549AbdJMJKe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 05:10:34 -0400
In-Reply-To: <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
Content-Language: ru
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org


> On 10/13/2017 12:59 AM, Alexandr Kuznetsov wrote:
>> Hi
>>
>>> It looks like probably the superblock of md0p2 and other data structures
>>> were corrupted during the lvm commands, and in turn this is triggering
>>> bugs with bcache (bcache should detect the situation and abort
>>> everything, but instead is left with the bucket_lock held and freezes).
>> This immediately rises questions about reliability and safety of lvm and
>> bcache.
> Neither is safe if you overwrite the superblock with an errant command.
> If you pvcreate'd on the backing device directly, or did something
> similarly, that would be expected to go badly.
>
>> I thought that lvm is old, mature and safe technology, but here it is
>> stuck, then manualy interrupted and result is catastrophic data corruption.
>> lvm sits on top of that sandwich of block devices, on layer of
>> /dev/bcache* devices. Another question here is how crazy lvm could
>> damage data outside of /dev/bcache* devices? This means that some
>> necessary io buffer range checks are missing inside bcache.
> I don't know what commands you ran.  I've never seen/heard of a bcache
> superblock corrupted, and I believe the mappings/shrink are appropriate.
I was not manipulating directly with backing devices or lvm pv's. I was 
not doing something illegal from lvm or bcache points of view, otherwise 
i would not write here, because then i would know that file system was 
killed by myself.
There was only lvcreate and lvremove commands that creates and removes 
logical volumes inside lvm, nothing more, there wasn't any direct access 
outside of /dev/bcache* devices. Thats why i wrote "This means that some 
necessary io buffer range checks are missing inside bcache". So how 
bcache allowed to damage data outside of bcache* devices if any access 
to them went through bcache, not directly? I'm sure thats a bug. Why 
bcache freezes when he meets corrupted data instead of reporting errors? 
I'm sure thats a bug.

> Sorry, no.  Other filesystems / block devices will not behave well if
> you overwrite their superblock, either.  This is not behavior bcache is
> expected to recover gracefully from (though it shouldn't hang).
>
> re: the dirty data in the 100GB part, having a filesystem with a
> superblock marked dirty is fine if the cache device is available.
>
> Mike
The cache device is available and it looks fine at first, but it behaves 
same way even if cache meets any backing device that marked as "clean". 
So i am not sure that everything is fine with caching device. I need at 
least to check it, and I ask for appropriate tool for that. Is it exist?
Registering any device (caching or backing) alone behaves nicely... at 
first sight. But if bcache tryes to connect cache and backing device 
marked "clean" to each other during register process, it hangs. That's 
all nasty because i was not doing anything wrong, but i lost my data due 
to bugs in both, lvm and bcache :(
