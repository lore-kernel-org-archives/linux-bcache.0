Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C292BC47082
	for <linux-bcache@archiver.kernel.org>; Tue,  8 Jun 2021 16:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0D4061002
	for <linux-bcache@archiver.kernel.org>; Tue,  8 Jun 2021 16:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhFHQs0 (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 8 Jun 2021 12:48:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60452 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhFHQs0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Jun 2021 12:48:26 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9EFBB219A9;
        Tue,  8 Jun 2021 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623170792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33jLIAvIm2z9Jg9x4C1CkV9izeapcj9TUgCOO9wW74U=;
        b=J6oGOLsIawBNEO5FldXZcP5ueTPO4+FIQoB/zOmX9hr5stCsRQX1pruRgrRsy6YFX5EzCD
        YDnTUplL2MHDduYKp7ZhuOUlSp3vYznSAx1wFMUMU3QqhvhZBkQSbJGb4OZFqz7nOulx99
        HXZcs7hZ4znZNDGLT6Agd074jDtIyf8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623170792;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33jLIAvIm2z9Jg9x4C1CkV9izeapcj9TUgCOO9wW74U=;
        b=HY6ShxTxAQynep9u9DtC5AFlkYljduQSTo7Joo+bcA3OVCVtvCEPxtbDtwISPvg97HYZcv
        GF8HH8D8zVjQInDg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 13B31118DD;
        Tue,  8 Jun 2021 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623170792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33jLIAvIm2z9Jg9x4C1CkV9izeapcj9TUgCOO9wW74U=;
        b=J6oGOLsIawBNEO5FldXZcP5ueTPO4+FIQoB/zOmX9hr5stCsRQX1pruRgrRsy6YFX5EzCD
        YDnTUplL2MHDduYKp7ZhuOUlSp3vYznSAx1wFMUMU3QqhvhZBkQSbJGb4OZFqz7nOulx99
        HXZcs7hZ4znZNDGLT6Agd074jDtIyf8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623170792;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33jLIAvIm2z9Jg9x4C1CkV9izeapcj9TUgCOO9wW74U=;
        b=HY6ShxTxAQynep9u9DtC5AFlkYljduQSTo7Joo+bcA3OVCVtvCEPxtbDtwISPvg97HYZcv
        GF8HH8D8zVjQInDg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id EvHfJ+aev2DZXQAALh3uQQ
        (envelope-from <colyli@suse.de>); Tue, 08 Jun 2021 16:46:30 +0000
Subject: Re: [PATCH v2 0/2] bcache fixes for Linux v5.13-rc6
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, hch@lst.de
References: <20210607125052.21277-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <974c6f2f-5a19-bd0a-5180-53e78c6d1a76@suse.de>
Date:   Wed, 9 Jun 2021 00:46:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607125052.21277-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/7/21 8:50 PM, Coly Li wrote:
> Hi Jens,
>
> This series is important for recent reported bcache panic partially
> triggered by recent bio changes since Linux v5.12.
>
> Current fix is 5th version since the first effort, it might not be
> perfect yet, but it survives from different workloads from Rolf,
> Thorsten and me for more than 1 week in total.
>
> Considering many people are waiting for a stable enough fix and it is
> kind of such fix. Please take them for Linux v5.13-rc6.
>
> Thank you in advance for taking care of them.

Hi Jens,

Could you please take a look on this ? Thanks.

Coly Li

