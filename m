Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03887ECAAD2
	for <linux-bcache@archiver.kernel.org>; Mon, 29 Aug 2022 16:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiH2Qyk (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiH2Qyk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2022 12:54:40 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C67844F9;
        Mon, 29 Aug 2022 09:54:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661792077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jn5lv59v49oqnVMTwm6OT5fVqI/p3Eaw+i6Y9Lw/b/Y=;
        b=WZ2JIPhVguqw2EqnPm+Ifm5BSbGcPLKh2kVJXBsSfSR0lgMNcrO6/A0HF1bpeRW9Okaup7
        Xi/jQYtMQvxNaoqUrSN/cGLSDfNus0kZl7TSL+MMyrs6onRJLjfNVruWyXG15gP1L5lfvh
        4geajB+IO1ucSth75TGmUer/o+153TQ=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        colyli@suse.de
Subject: Time stats library (from bcache/bcachefs) & generic latency instrumentation
Date:   Mon, 29 Aug 2022 12:53:41 -0400
Message-Id: <20220829165344.2958640-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hey Coly, this is a fragment from a larger patch series - I wanted to send it
out to you now for review because it changes the bcache sysfs interface for
time_stats.

This series takes the time_stats code from bcachefs (which has some additional
improvements), moves it to lib/ converts bcache to use it (otherwise we get
clashes with the time_stats name) - and uses it for some really cool new latency
instrumentation.

These patches won't apply/build, full patch series for any interested is here:

https://evilpiepirate.org/git/bcachefs.git/log/?h=alloc_tags


