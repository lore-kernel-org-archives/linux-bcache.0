From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: How well does bcache cope with frequently changing cache device?
Date: Sun, 4 Sep 2016 19:08:04 +0200
Message-ID: <CAFvQSYTEMFptL92JhbGgKRNEkFFLm5z5nZM1hksSSeon2bX=dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:32843 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbcIDRJa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Sep 2016 13:09:30 -0400
Received: by mail-qk0-f177.google.com with SMTP id z190so172804242qkc.0
        for <linux-bcache@vger.kernel.org>; Sun, 04 Sep 2016 10:08:06 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I am thinking about working with a root-fs on an external disk which
can be shared amongst different computers.
For this use-case the internal SSD could be used as caching device,
speeding up the access to the relativly slow external storage.

What I wonder is how well bcache can cope with changing caching
devices? Great would be if bcache could detect when a backing decive
was used with a different caching device in the meantime and
automatically invalidate the old/stale caching device - but to keep
the cache unmodified when this was not the case.

Is this use-case possible with bcache?

Thank you in advance, Clemens
