Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473B8C4338F
	for <linux-bcache@archiver.kernel.org>; Thu, 29 Jul 2021 00:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B4D760FD7
	for <linux-bcache@archiver.kernel.org>; Thu, 29 Jul 2021 00:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhG2Anq (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:43:46 -0400
Received: from mx.ewheeler.net ([173.205.220.69]:42211 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232950AbhG2Anq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Jul 2021 20:43:46 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id 02BD21A
        for <linux-bcache@vger.kernel.org>; Thu, 29 Jul 2021 00:43:44 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ewheeler.net 02BD21A
Authentication-Results: mail.ewheeler.net; dkim=none
Date:   Thu, 29 Jul 2021 00:43:43 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@pop.dreamhost.com
To:     linux-bcache@vger.kernel.org
Subject: Can you grow a bcache cachedev without reformat?
Message-ID: <alpine.LRH.2.21.2107290042300.27704@pop.dreamhost.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello all,

I know you can grow a backing device by unregister/re-register, but what 
about a cache dev?  

Will bcache detect a large cache volume if I unregister/re-register, or 
does it need reformatted with make-bcache -C ?


--
Eric Wheeler
