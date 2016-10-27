From: Shay Gover <govershay@gmail.com>
Subject: Re: bcache and suspend
Date: Thu, 27 Oct 2016 22:55:45 +0300
Message-ID: <CANM5d8f7o35+Es9629Pb7Em2nKVROjiT=V8iN-qv=U4L4KUJ+g@mail.gmail.com>
References: <CANM5d8eOsABz6=KapRnF=evv1oXkHgsKxbEysZXMJ_fkR=rCSA@mail.gmail.com>
 <5812595E.2010903@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37691 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933171AbcJ0T4J (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Oct 2016 15:56:09 -0400
Received: by mail-wm0-f52.google.com with SMTP id 140so40260249wmv.0
        for <linux-bcache@vger.kernel.org>; Thu, 27 Oct 2016 12:56:08 -0700 (PDT)
In-Reply-To: <5812595E.2010903@megasoft.be>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>
Cc: linux-bcache@vger.kernel.org

Define provider.

I want to use it for my personal PC. I'm using arch. What exacly do I
need to do? disable cache before suspend?

Thanks

On Thu, Oct 27, 2016 at 10:45 PM, Killian De Volder
<killian.de.volder@megasoft.be> wrote:
> Bcache "supports" suspend.
> However, like all file-systems, you cannot mount it while you are resuming.
> And bcache is basically automount.
>
> I use bcache with suspend, but I have taken special precautions to ensure bcache is never active
> before attempting a resume. To do this I wrote my own initramfs.
> If you are using a prebuild initramfs, ask your provider if it supports this.
>
> For more info:
> https://bcache.evilpiepirate.org/FAQ/ "Can I use bcache with suspend/resume?"
>
> Killian De Volder
>
>
> On 27-10-16 19:56, Shay Gover wrote:
>> Hi,
>>
>> I saw this:
>> https://patchwork.kernel.org/patch/8879681/
>>
>> So does bcache support suspend?
>>
>> Thanks,
>>
>> Shay Gover
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
