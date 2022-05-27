Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E57C433F5
	for <linux-bcache@archiver.kernel.org>; Fri, 27 May 2022 17:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbiE0R3K (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 27 May 2022 13:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240684AbiE0R3J (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 13:29:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97C34DF4D
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 10:28:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8BEED1F855;
        Fri, 27 May 2022 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653672538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4U40bhosnjOpPM/aAy2kNubZ9C0Q3yL6zHOLnC4aaks=;
        b=J/RLNPPkBiDTVRzsv48xjYr7j3efvbQHTd9ElDg0Gjy39ypD2cHG7OK0CgIjC/eI4Uj2Xz
        cC8GmnQpsHjuy/DxluWoT4dMgDmoHoSKEGRvZaG234aY50E65Ng5jhyZd9SdNsqmwF3Un3
        RPezyWCSlAAhmCxGNFFe8/TrBhSx7Zs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653672538;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4U40bhosnjOpPM/aAy2kNubZ9C0Q3yL6zHOLnC4aaks=;
        b=eQCO0c9V+FJya7ss12zqvyTvz+0TZmpVHue42VQtnbdMgf3yj6Flw9kmBtm3sfCJiyemVU
        5yuL94/hXMS94hCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 830B013A84;
        Fri, 27 May 2022 17:28:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ia7KH1oKkWK5NwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 27 May 2022 17:28:58 +0000
MIME-Version: 1.0
Date:   Sat, 28 May 2022 01:28:58 +0800
From:   colyli <colyli@suse.de>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
In-Reply-To: <5a9fe523-d88a-b9e-479f-ae6dbb3d596e@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <a3830c54-5e88-658f-f0ef-7ac675090b24@suse.de>
 <5a9fe523-d88a-b9e-479f-ae6dbb3d596e@ewheeler.net>
User-Agent: Roundcube Webmail
Message-ID: <56405053a802525729f4e9f08e7861e5@suse.de>
X-Sender: colyli@suse.de
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

在 2022-05-27 03:15，Eric Wheeler 写道：
> On Mon, 23 May 2022, Coly Li wrote:
>> On 5/18/22 9:22 AM, Eric Wheeler wrote:
>> > Some time ago you ordered an an SSD to test the 4k cache issue, has that
>> > been fixed?  I've kept an eye out for the patch but not sure if it was
>> > released.
>> 
>> Yes, I got the Intel P3700 PCIe SSD to fix the 4Kn unaligned I/O issue
>> (borrowed from a hardware vendor). The new situation is, current 
>> kernel does
>> the sector size alignment checking quite earlier in bio layer, if the 
>> LBA is
>> not sector size aligned, it is rejected in the bio code, and the 
>> underlying
>> driver doesn't have chance to see the bio anymore. So for now, the 
>> unaligned
>> LBA for 4Kn device cannot reach bcache code, that's to say, the 
>> original
>> reported condition won't happen now.
> 
> The issue is not with unaligned 4k IOs hitting /dev/bcache0 because you
> are right, the bio layer will reject those before even getting to
> bcache:
> 
> The issue is that the bcache cache metadata sometimes makes metadata or
> journal requests from _inside_ bcache that are not 4k aligned.  When
> this happens the bio layer rejects the request from bcache (not from
> whatever is above bcache).
> 
> Correct me if I misunderstood what you meant here, maybe it really was
> fixed.  Here is your response from that old thread that pointed at
> unaligned key access where you said "Wow, the above lines are very
> informative, thanks!"
> 

It was not fixed, at least I didn't do it on purpose. Maybe it was 
avoided
by other fixes, e.g. the oversize bkey fix. But I don't have evidence 
the
issue was fixed.

> bcache: check_4k_alignment() KEY_OFFSET(&w->key) is not 4KB aligned:
> 15725385535
>   https://www.spinics.net/lists/linux-bcache/msg06076.html
> 
> In that thread Kent sent a quick top-post asking "have you checked 
> extent
> merging?"
> 	https://www.spinics.net/lists/linux-bcache/msg06077.html
> 

It embarrassed me that I received your informative debug information, 
and I
glared very hard at the code for quite long time, but didn't have any 
clue
that how such problem may happen in the extent related code.

Since you reported the issue and I believe you, I will keep my eyes on 
the
non-aligned 4Kn issue for bcache internal I/O. Hope someday I may have 
idea
suddenly to point out where the problem is, and fix it.


>> And after this observation, I stopped my investigation on the 
>> unaligned sector
>> size I/O on 4Kn device, and returned the P3700 PCIe SSD to the 
>> hardware
>> vendor.
> 
> Hmm, sorry that it wasn't reproduced.  I hope I'm wrong, but if bcache 
> is
> generating the 4k-unaligned requests against the cache meta then this 
> bug
> might still be floating around for "4Kn" cache users.
> 

I don't think you were wrong, you are people whom I believe :-) It just 
needs
time and luck...

Coly Li
