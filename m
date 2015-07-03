From: Yurii Kolesnykov <yurikoles@gmail.com>
Subject: Re: change/recreate cache device?
Date: Fri, 3 Jul 2015 23:35:40 +0300
Message-ID: <5596F21C.4070100@gmail.com>
References: <CAC=t97ATr7fd-_4_14vggBVqvprnKWHDMny6TknQ5DdqBeS_xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34914 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbbGCUfp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Jul 2015 16:35:45 -0400
Received: by lagh6 with SMTP id h6so95985354lag.2
        for <linux-bcache@vger.kernel.org>; Fri, 03 Jul 2015 13:35:43 -0700 (PDT)
In-Reply-To: <CAC=t97ATr7fd-_4_14vggBVqvprnKWHDMny6TknQ5DdqBeS_xg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Donald Pearson <donaldwhpearson@gmail.com>, linux-bcache@vger.kernel.org

Yes, I had same issue many times. To resolve it you need to `echo 1 > /sys/fs/bcache/<UUID>/stop`, but maybe even `echo <UUID> > /sys/block/bcacheN/bcache/detach` before it.

On 03.07.15 23:25, Donald Pearson wrote:
> This is my first crack at bcache and I configured a cache device with
> defaults using make-bcache -C /dev/sda
> 
> Now I've got better info on my SSD and know what the block and bucket
> sizes should be, however I can't run the command again with errors
> that the device is busy.
> 
> I never did anythign beyond just creating the cache and backing
> devices.  I never registered the cache device, never created a
> filesystem.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
