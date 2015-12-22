From: Denis Bychkov <manover@gmail.com>
Subject: Re: dynamically resizing bcache devices
Date: Tue, 22 Dec 2015 13:24:55 -0500
Message-ID: <CAO2mnoyLrO9_GonWXmEpsPGVnKsfY-fs4QDBi-soo5eoQ2GycQ@mail.gmail.com>
References: <20151222124044.Horde.yBZenQERTNZN7P0HR3WeoI_@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35399 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbLVSY4 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Dec 2015 13:24:56 -0500
Received: by mail-lb0-f170.google.com with SMTP id bc4so35491599lbc.2
        for <linux-bcache@vger.kernel.org>; Tue, 22 Dec 2015 10:24:56 -0800 (PST)
In-Reply-To: <20151222124044.Horde.yBZenQERTNZN7P0HR3WeoI_@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

Why is it so important to grow the backing device online, without even
re-registering it? It should it be enough to unmount whatever FS is on
top of it, unregister the device and register it again to "resize" it.
(Or reboot the system for that matter). Is there really a pressuring
need to do it on the fly?

On Tue, Dec 22, 2015 at 6:40 AM, Jens-U. Mozdzen <jmozdzen@nde.ag> wrote:
> Hi,
>
> an earlier, similar question went by unanswered, so let me give it another
> try:
>
> I have set up a bcache device on top of DMRAID devices for cache and backing
> device.
>
> While I can dynamically resize both RAIDs, the bcache device will not catch
> up with the changes "live". This conforms to what Kent wrote in 2012
> (http://comments.gmane.org/gmane.linux.kernel.bcache.devel/249):
>
> --- cut here ---
> For the backing device, I think things will just work - you'll just
> have to close and reopen the backing device in order for bcache to
> notice the new size. Bcache's superblock doesn't remember the size, it
> just goes off of what the size of the backing device is when it's
> registered.
>
> There's currently no way to make bcache notice the backing device has
> grown to do it at runtime, though that ought to be fairly simple too.
> --- cut here ---
>
> If this currently is still not implemented, has anyone started to work on
> some "resizebcache" tool, if only handling the backing device?
>
> Regards,
> Jens
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

Denis
