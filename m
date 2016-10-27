From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: bcache and suspend
Date: Thu, 27 Oct 2016 21:45:34 +0200
Message-ID: <5812595E.2010903@megasoft.be>
References: <CANM5d8eOsABz6=KapRnF=evv1oXkHgsKxbEysZXMJ_fkR=rCSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43150 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755409AbcJ0Tpi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Oct 2016 15:45:38 -0400
In-Reply-To: <CANM5d8eOsABz6=KapRnF=evv1oXkHgsKxbEysZXMJ_fkR=rCSA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Shay Gover <govershay@gmail.com>, linux-bcache@vger.kernel.org

Bcache "supports" suspend.
However, like all file-systems, you cannot mount it while you are resuming.
And bcache is basically automount.

I use bcache with suspend, but I have taken special precautions to ensure bcache is never active
before attempting a resume. To do this I wrote my own initramfs.
If you are using a prebuild initramfs, ask your provider if it supports this.

For more info:
https://bcache.evilpiepirate.org/FAQ/ "Can I use bcache with suspend/resume?"

Killian De Volder


On 27-10-16 19:56, Shay Gover wrote:
> Hi,
> 
> I saw this:
> https://patchwork.kernel.org/patch/8879681/
> 
> So does bcache support suspend?
> 
> Thanks,
> 
> Shay Gover
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
