From: Donald Pearson <donaldwhpearson@gmail.com>
Subject: Re: change/recreate cache device?
Date: Fri, 3 Jul 2015 15:51:13 -0500
Message-ID: <CAC=t97BREcSCV4kO2vdMkpOHJg6qR62sJzCdkDCA+SwQTMqjQg@mail.gmail.com>
References: <CAC=t97ATr7fd-_4_14vggBVqvprnKWHDMny6TknQ5DdqBeS_xg@mail.gmail.com>
 <5596F21C.4070100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34264 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbbGCUve (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Jul 2015 16:51:34 -0400
Received: by oigx81 with SMTP id x81so84519493oig.1
        for <linux-bcache@vger.kernel.org>; Fri, 03 Jul 2015 13:51:33 -0700 (PDT)
In-Reply-To: <5596F21C.4070100@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yurii Kolesnykov <yurikoles@gmail.com>
Cc: linux-bcache@vger.kernel.org

That was the ticket, thank you sir!

On Fri, Jul 3, 2015 at 3:35 PM, Yurii Kolesnykov <yurikoles@gmail.com> wrote:
> Yes, I had same issue many times. To resolve it you need to `echo 1 > /sys/fs/bcache/<UUID>/stop`, but maybe even `echo <UUID> > /sys/block/bcacheN/bcache/detach` before it.
>
> On 03.07.15 23:25, Donald Pearson wrote:
>> This is my first crack at bcache and I configured a cache device with
>> defaults using make-bcache -C /dev/sda
>>
>> Now I've got better info on my SSD and know what the block and bucket
>> sizes should be, however I can't run the command again with errors
>> that the device is busy.
>>
>> I never did anythign beyond just creating the cache and backing
>> devices.  I never registered the cache device, never created a
>> filesystem.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
