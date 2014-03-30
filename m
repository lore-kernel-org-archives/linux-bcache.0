From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Issue (as expected) when upgrading from 3.12 to 3.13.7
Date: Sun, 30 Mar 2014 14:08:57 +0200
Message-ID: <53380959.9030004@gmail.com>
References: <lh8t08$1dd$1@ger.gmane.org> <20140330114747.GA15353@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57854 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaC3MHk (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 30 Mar 2014 08:07:40 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so2126487wiv.10
        for <linux-bcache@vger.kernel.org>; Sun, 30 Mar 2014 05:07:39 -0700 (PDT)
In-Reply-To: <20140330114747.GA15353@sucs.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>, Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

On 03/30/2014 01:47 PM, Sitsofe Wheeler wrote:
> Hi,
> 
> On Sun, Mar 30, 2014 at 12:53:12PM +0200, Francis Moreau wrote:
>>
>> As I was expecting I'm getting new issues with bcache after upgrading my
>> kernel:
>>
>> [Mar30 12:24] INFO: task bcache_writebac:155 blocked for more than 120
>> seconds.
>> [  +0.000007]       Not tainted 3.13.7-1-ARCH #1
>> [  +0.000002] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [  +0.000003] bcache_writebac D 0000000000000000     0   155      2
>> 0x00000000
>> [  +0.000006]  ffff8804049c5eb8 0000000000000046 ffff880405816c00
>> ffff8804049c5fd8
>> [  +0.000005]  0000000000014440 0000000000014440 ffff880405816c00
>> ffff8804049c5e38
>> [  +0.000004]  ffffffff810925fa 24448b48e0d83524 fa83ffffee31e918
>> 0000000000000046
>> [  +0.000004] Call Trace:
>> [  +0.000010]  [<ffffffff810925fa>] ? try_to_wake_up+0x1fa/0x2c0
>> [  +0.000006]  [<ffffffff81092712>] ? default_wake_function+0x12/0x20
>> [  +0.000005]  [<ffffffff810a2538>] ? __wake_up_common+0x58/0x90
>> [  +0.000023]  [<ffffffffa03c7470>] ? read_dirty_endio+0x60/0x60 [bcache]
>> [  +0.000005]  [<ffffffff81516239>] schedule+0x29/0x70
>> [  +0.000006]  [<ffffffff8108358d>] kthread+0xad/0xf0
>> [  +0.000005]  [<ffffffff810834e0>] ? kthread_create_on_node+0x180/0x180
>> [  +0.000005]  [<ffffffff81521abc>] ret_from_fork+0x7c/0xb0
>> [  +0.000005]  [<ffffffff810834e0>] ? kthread_create_on_node+0x180/0x180
>>
>> That's just sad to see how unstable was/is bcache sub system and I still
>> don't understand why it was not marked as experimental.
>>
>> 3.12 was/is buggy when used with writeback mode, and I just had to live
>> with cache-through. I tried to get some helps (and others too) but no
>> answers.
>>
>> I read there were issue with 3.13, so I delayed my kernel upgrade as far
>> I could due to this. I was hoping that issues were fixed in 3.13.x
>> stable tree but apparently not.
>>
>> Hopefully this one will not be ignored.
> 
> Francis - I've found it helps if you add all the relevant addresses
> mentioned in https://www.kernel.org/doc/linux/MAINTAINERS . For this
> mail I'm going to explicitly CC Kent to help this get noticed.
> Additionally do you also see this problem with 3.14?
> 

Sorry 3.14 is not available yet on my distro.

Thanks
