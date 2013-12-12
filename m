From: Pete Eby <relative.prime@gmail.com>
Subject: Re: Unable to create /dev/bcacheN after initial creation
Date: Thu, 12 Dec 2013 10:02:37 -0500
Message-ID: <CAFRtjp-O0SZdBP0xi=LLog5C-KW0Up0oZm+N_o86-o7oQZzaOg@mail.gmail.com>
References: <CAFRtjp_+j2RcsEkmsBLjAse7dP+1jXzEkxRAGGLnD=taaMG6Jg@mail.gmail.com>
	<52A87E88.2000003@bahj.com>
	<20131212000144.GV1848@teapot>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56646 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LLPCi (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 12 Dec 2013 10:02:38 -0500
Received: by mail-ve0-f176.google.com with SMTP id oz11so375765veb.7
        for <linux-bcache@vger.kernel.org>; Thu, 12 Dec 2013 07:02:37 -0800 (PST)
In-Reply-To: <20131212000144.GV1848@teapot>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <bcache@mfedv.net>
Cc: Zachary Palmer <zep_bcache@bahj.com>, linux-bcache@vger.kernel.org

Hi Matthias and Zachary,

Thanks for the help - I was able to mount the device after manually attaching.

Now, to just figure out the last pieces preventing it from mounting as
the root device, which it looks like Zachary's tips should help with.

On Wed, Dec 11, 2013 at 7:01 PM, Matthias Ferdinand <bcache@mfedv.net> wrote:
> [disclaimer: haven't tried bcache on / myself]
>
> from the manual steps given, I think there needs to also be an attaching
> operation:
>
>   echo "<cset-uuid>" >/sys/block/dm-xy/bcache/attach

Brilliant - that's what I needed. Can't believe I missed that in the manual.

> Not sure why often the backing device must be explicitly attached to the
> caching device to make /dev/bcache<n> show up. Perhaps some cleanup left
> to do, so it doesn't want to be mountable without its caching device.
>
> You should put "bcache" into /etc/modules und run update-initramfs,
> otherwise the bcache module will not be ready when the kernel needs it
> for mounting the real root device.

I did put bcache into /etc/sysconfig/kernel INITRD_MODULES (suse) and
generated a new initrd

> More tweaks might be necessary, don't know if that already gives you the
> udev rules inside the initramfs (it should, if you have bcache-tools
> installed which provide initramfs-tools/hooks/bcache).
> Regards
> Matthias

bcache-tools, with the initrd rules, in installed in Suse as well.
lsinitrd shows bcache.ko and /usr/lib/udev/bcache-register are
present.

I'll follow Zachary's tips next - thank you both very much!

Pete
