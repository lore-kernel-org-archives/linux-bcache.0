From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker
 merged)
Date: Wed, 10 Jun 2020 07:32:54 -0400
Message-ID: <20200610113254.GA824770@zaphod.evilpiepirate.org>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <3828047.K31vBF4JiT@t460-skr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgFJLdC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jun 2020 07:33:02 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBF7C03E96B
        for <linux-bcache@vger.kernel.org>; Wed, 10 Jun 2020 04:33:02 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id l17so1588295qki.9
        for <linux-bcache@vger.kernel.org>; Wed, 10 Jun 2020 04:33:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <3828047.K31vBF4JiT@t460-skr>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan K <shadow_7@gmx.net>
Cc: linux-bcache@vger.kernel.org

On Wed, Jun 10, 2020 at 01:02:10PM +0200, Stefan K wrote:
> ... one year later ...
> 
> what is the status now? the latest update on patreon is a few month old.
> What are the blockers to merge bcachefs into the kernel?
> 
> I hope that the bcachefs thing will be merged soon.

Status update coming. Did journalling of updates to interior btree nodes a few
months ago to get rid of FUA writes and for other reasons and that turned out to
be more work than expected; still debugging the new btree key cache code which
is needed to fully fix recovery from unclean shutdown.

Main blocker for merging is the dio cache coherency thing. That and working
through all known bugs. There's an outstanding data corruption bug someone in
the IRC channel is helping track down. Bleh. Debugging is endless.
