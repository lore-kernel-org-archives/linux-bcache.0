From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache failure hangs something in kernel
Date: Thu, 12 Oct 2017 11:12:20 -0700
Message-ID: <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:51566 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdJLSMW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Oct 2017 14:12:22 -0400
Received: by mail-pf0-f175.google.com with SMTP id n14so5988398pfh.8
        for <linux-bcache@vger.kernel.org>; Thu, 12 Oct 2017 11:12:22 -0700 (PDT)
In-Reply-To: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

Hi-- sorry you are having trouble..

On 10/12/2017 05:49 AM, Alexandr Kuznetsov wrote:
> Hellow.
> 
> Can any one help me? Two days ago i encountered bcache failure and since
> then i can't boot my system Ubuntu 16.04 amd64.
> Now when cache and backend devices meets each other during register
> process, something hangs inside the kernel and such messages appear in
> dmesg:

[snip]

> 54 backing devices show:
>     dev.data.cache_mode    1 [writeback]
>     dev.data.cache_state    1 [clean]
>     cset.uuid        d93ae507-b4bb-48ef-8d64-fa9329a08a39
> One backing device (md0p3) show:
>     dev.data.cache_mode    1 [writeback]
>     dev.data.cache_state    1 [dirty]
>     cset.uuid        d93ae507-b4bb-48ef-8d64-fa9329a08a39
> And one strange device (md0p2) show:
>     dev.data.cache_mode    1 [writeback]
>     dev.data.cache_state    0 [detached]
>     cset.uuid        9a6aeb43-5f33-45ca-a1b0-a1277e3e5c44

It looks like probably the superblock of md0p2 and other data structures
were corrupted during the lvm commands, and in turn this is triggering
bugs with bcache (bcache should detect the situation and abort
everything, but instead is left with the bucket_lock held and freezes).

One thing you could do possibly do is blacklist bcache in your
/etc/modules, and then attach all the devices one by one, (not including
md0p2), to get at the data on all the other volumes.

Also, 54 of the backing devices are clean-- they have no dirty data in
the cache-- so they can be mounted directly if you want.

Mike
