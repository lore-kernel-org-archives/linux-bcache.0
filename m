From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v3 00/13] bcache: device failure handling improvement
Date: Thu, 25 Jan 2018 21:51:37 -0800
Message-ID: <CAJ+L6qdLHXzOyKsacCdwB3QKKdnWdxo3kna-Zff8Bv2EfnmR8g@mail.gmail.com>
References: <20180114144236.28213-1-colyli@suse.de> <87po5ykiaw.fsf@esperi.org.uk>
 <1664591662.20180125063516@pvgoran.name> <874ln9hilm.fsf@esperi.org.uk>
 <355593907.20180126071541@pvgoran.name> <f2034e77-d351-cb50-d8e0-853ddc48db59@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:36439 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbeAZFvj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Jan 2018 00:51:39 -0500
Received: by mail-qt0-f179.google.com with SMTP id z11so25221569qtm.3
        for <linux-bcache@vger.kernel.org>; Thu, 25 Jan 2018 21:51:38 -0800 (PST)
In-Reply-To: <f2034e77-d351-cb50-d8e0-853ddc48db59@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Pavel Goran <via-bcache@pvgoran.name>, Nix <nix@esperi.org.uk>, linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org

Hey Coly,

On Thu, Jan 25, 2018 at 8:56 PM, Coly Li <colyli@suse.de> wrote:
> In order to make the failure handling simple and fast, I will not
> distinct each bcache device whether it has dirty data on cache set. Once
> the cache set is dirty, all attached bcache devices will be stopped.

Surely it shouldn't stop any writethrough/writearound ones though, right?

> It seems when this option is enabled by users, it should work for
> writeback and writethrough, and no side effect to writearound and non.

Writethrough should be the same as writearound, shouldn't it?

Thanks,

Mike
