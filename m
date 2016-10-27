From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: bcache and suspend
Date: Fri, 28 Oct 2016 00:12:42 +0200
Message-ID: <58127BDA.2080805@megasoft.be>
References: <CANM5d8eOsABz6=KapRnF=evv1oXkHgsKxbEysZXMJ_fkR=rCSA@mail.gmail.com>
 <5812595E.2010903@megasoft.be>
 <CANM5d8f7o35+Es9629Pb7Em2nKVROjiT=V8iN-qv=U4L4KUJ+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:32978 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942525AbcJ0WWl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Oct 2016 18:22:41 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id 95FBD47B109
        for <linux-bcache@vger.kernel.org>; Fri, 28 Oct 2016 00:12:52 +0200 (CEST)
In-Reply-To: <CANM5d8f7o35+Es9629Pb7Em2nKVROjiT=V8iN-qv=U4L4KUJ+g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Shay Gover <govershay@gmail.com>
Cc: linux-bcache@vger.kernel.org

What initramfs are you using ?

If you want a simple answer:
- Use a kernel without bcache build in.
- Do not modprobe bcache before resume.

Killian De Volder


On 27-10-16 21:55, Shay Gover wrote:
> Define provider.
> 
> I want to use it for my personal PC. I'm using arch. What exacly do I
> need to do? disable cache before suspend?
> 
> Thanks
> 
> On Thu, Oct 27, 2016 at 10:45 PM, Killian De Volder
> <killian.de.volder@megasoft.be> wrote:
>> Bcache "supports" suspend.
>> However, like all file-systems, you cannot mount it while you are resuming.
>> And bcache is basically automount.
>>
>> I use bcache with suspend, but I have taken special precautions to ensure bcache is never active
>> before attempting a resume. To do this I wrote my own initramfs.
>> If you are using a prebuild initramfs, ask your provider if it supports this.
>>
>> For more info:
>> https://bcache.evilpiepirate.org/FAQ/ "Can I use bcache with suspend/resume?"
>>
>> Killian De Volder
>>
>>
>> On 27-10-16 19:56, Shay Gover wrote:
>>> Hi,
>>>
>>> I saw this:
>>> https://patchwork.kernel.org/patch/8879681/
>>>
>>> So does bcache support suspend?
>>>
>>> Thanks,
>>>
>>> Shay Gover
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
