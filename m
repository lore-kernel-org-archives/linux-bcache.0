Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB64C47088
	for <linux-bcache@archiver.kernel.org>; Wed, 26 May 2021 16:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E66C8613CA
	for <linux-bcache@archiver.kernel.org>; Wed, 26 May 2021 16:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhEZQ0f (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 26 May 2021 12:26:35 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:41776 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhEZQ0e (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 26 May 2021 12:26:34 -0400
X-Greylist: delayed 1512 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2021 12:26:34 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 14QFxmFP002667
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 26 May 2021 16:59:48 +0100
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: [PATCH v4] bcache: avoid oversized read request in cache missing code path
References: <20210526151450.45211-1-colyli@suse.de>
Emacs:  Our Lady of Perpetual Garbage Collection
Date:   Wed, 26 May 2021 16:59:48 +0100
In-Reply-To: <20210526151450.45211-1-colyli@suse.de> (Coly Li's message of
        "Wed, 26 May 2021 23:14:50 +0800")
Message-ID: <87tumpiiyz.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=2 Fuz1=2 Fuz2=2
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 26 May 2021, Coly Li said:
> Current problmatic code can be partially found since Linux v5.13-rc1,
> therefore all maintained stable kernels should try to apply this fix.

I thought this crash was observed with 5.12 originally? (I know that's
why I'm still on 5.11 :) )
