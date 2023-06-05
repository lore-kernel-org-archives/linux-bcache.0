Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A0FC7EE23
	for <linux-bcache@archiver.kernel.org>; Mon,  5 Jun 2023 19:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbjFETzJ (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbjFETyw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Jun 2023 15:54:52 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9C090
        for <linux-bcache@vger.kernel.org>; Mon,  5 Jun 2023 12:54:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id F22A346;
        Mon,  5 Jun 2023 12:54:51 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Hp9B8h5bj4YN; Mon,  5 Jun 2023 12:54:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 1DA8F45;
        Mon,  5 Jun 2023 12:54:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 1DA8F45
Date:   Mon, 5 Jun 2023 12:54:50 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Alcatraz NG <ovearj@gmail.com>
cc:     linux-bcache@vger.kernel.org
Subject: Re: Bcache accelerated LVM LV device doesn't come up after reboot
In-Reply-To: <CAFvjXT7N8aVKP-nUHJQ407jE7Bf5Kn1wNkTSiPZ2EdAMHd01YQ@mail.gmail.com>
Message-ID: <98cda4b9-2e83-c7a6-a9c6-d09aaffb4589@ewheeler.net>
References: <CAFvjXT7N8aVKP-nUHJQ407jE7Bf5Kn1wNkTSiPZ2EdAMHd01YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 5 Jun 2023, Alcatraz NG wrote:

> Hello,
> 
> I am using bcache to accelerate my LVM LVs (lvmcache is not ideal
> approach for some reason). But every time I reboot, all bcache devices
> just disappear, and doesn't come up until `partprobe` being executed
> manually.

It sounds like the udev rules aren't configured.  Do you have this file 
from the bcache-tools package (the number "69" may differ):
 /usr/lib/udev/rules.d/69-bcache.rules

Depending on your setup you might have to rebuild the initramfs, too (ie 
`dracut` or `update-initramfs` or whatever your distro uses).


--
Eric Wheeler



> 
> Is there any method to let bcache bring those devices up automatically
> when the system is up? The `partprobe` workaround isn't ideal as most
> applications will fail due to the non-existent device. I have tried to
> adjust some module load configurations, but it did not work.
> 
> Many thanks
> 
