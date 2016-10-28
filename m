From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: bcache and suspend
Date: Fri, 28 Oct 2016 13:26:01 +0200
Message-ID: <581335C9.3050403@megasoft.be>
References: <CANM5d8eOsABz6=KapRnF=evv1oXkHgsKxbEysZXMJ_fkR=rCSA@mail.gmail.com>
 <5812595E.2010903@megasoft.be>
 <CANM5d8f7o35+Es9629Pb7Em2nKVROjiT=V8iN-qv=U4L4KUJ+g@mail.gmail.com>
 <58127BDA.2080805@megasoft.be>
 <CANM5d8disVGZ0LCDEVd70Z_cY=9T3u6fNQyJzihS1FJ_NRCk5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:57686 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbcJ1L0H (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 07:26:07 -0400
In-Reply-To: <CANM5d8disVGZ0LCDEVd70Z_cY=9T3u6fNQyJzihS1FJ_NRCk5g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Shay Gover <govershay@gmail.com>
Cc: linux-bcache@vger.kernel.org

Sorry,

That doesn't change a thing.
Did a quick search on the internet, can't find in 3 mins what initramfs your distro uses (per default).
(My pc is slow atm ;)

Regards,
Killian De Volder

On 28-10-16 12:02, Shay Gover wrote:
> I have no Idea what you just said. :(
> 
> I'm using the one provided by arch.
> 
> As far as I know, initramfs is relevant only if I intend to use bcache
> for my root partition. I don't. I'm going to use it for my /home
> partition. Does this change something?
> 
> On Fri, Oct 28, 2016 at 1:12 AM, Killian De Volder
> <killian.de.volder@megasoft.be> wrote:
>> What initramfs are you using ?
>>
>> If you want a simple answer:
>> - Use a kernel without bcache build in.
>> - Do not modprobe bcache before resume.
>>
>> Killian De Volder
>>
>>
>> On 27-10-16 21:55, Shay Gover wrote:
>>> Define provider.
>>>
>>> I want to use it for my personal PC. I'm using arch. What exacly do I
>>> need to do? disable cache before suspend?
>>>
>>> Thanks
>>>
>>> On Thu, Oct 27, 2016 at 10:45 PM, Killian De Volder
>>> <killian.de.volder@megasoft.be> wrote:
>>>> Bcache "supports" suspend.
>>>> However, like all file-systems, you cannot mount it while you are resuming.
>>>> And bcache is basically automount.
>>>>
>>>> I use bcache with suspend, but I have taken special precautions to ensure bcache is never active
>>>> before attempting a resume. To do this I wrote my own initramfs.
>>>> If you are using a prebuild initramfs, ask your provider if it supports this.
>>>>
>>>> For more info:
>>>> https://bcache.evilpiepirate.org/FAQ/ "Can I use bcache with suspend/resume?"
>>>>
>>>> Killian De Volder
>>>>
>>>>
>>>> On 27-10-16 19:56, Shay Gover wrote:
>>>>> Hi,
>>>>>
>>>>> I saw this:
>>>>> https://patchwork.kernel.org/patch/8879681/
>>>>>
>>>>> So does bcache support suspend?
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Shay Gover
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
