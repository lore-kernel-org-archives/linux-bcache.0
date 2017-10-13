From: Alexandr Kuznetsov <progmachine@xenlab.one>
Subject: Re: bcache failure hangs something in kernel
Date: Fri, 13 Oct 2017 10:59:08 +0300
Message-ID: <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from forward103j.mail.yandex.net ([5.45.198.246]:59530 "EHLO
        forward103j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753320AbdJMIFp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 04:05:45 -0400
In-Reply-To: <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
Content-Language: ru
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org

Hi

> It looks like probably the superblock of md0p2 and other data structures
> were corrupted during the lvm commands, and in turn this is triggering
> bugs with bcache (bcache should detect the situation and abort
> everything, but instead is left with the bucket_lock held and freezes).
This immediately rises questions about reliability and safety of lvm and 
bcache.
I thought that lvm is old, mature and safe technology, but here it is 
stuck, then manualy interrupted and result is catastrophic data corruption.
lvm sits on top of that sandwich of block devices, on layer of 
/dev/bcache* devices. Another question here is how crazy lvm could 
damage data outside of /dev/bcache* devices? This means that some 
necessary io buffer range checks are missing inside bcache.

> One thing you could do possibly do is blacklist bcache in your
> /etc/modules, and then attach all the devices one by one, (not including
> md0p2), to get at the data on all the other volumes.
>
> Also, 54 of the backing devices are clean-- they have no dirty data in
> the cache-- so they can be mounted directly if you want.
Unfortunately this md0p* block devices are not separate from each other 
- there is one 2Tb volume on top of them inside lvm. Loss of one 100Gib 
part and dirty data in another 100Gib part can kill entire file system 
with very high probability. Yesterday I have read that bcache failures 
are nasty, because file system roots data often resides on cache and is 
dirty on backing device.
Is there any tool like fsck exist, that can check and may be try to 
recover data from caching and backing devices? Or developers can get 
this corrupted images to experiment for bugfixing?
