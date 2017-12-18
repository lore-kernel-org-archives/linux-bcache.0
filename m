From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache shutdown sequence
Date: Mon, 18 Dec 2017 10:23:22 -0800
Message-ID: <CAJ+L6qeo9Zu1+jTYORbipNVv1JNkXgzGwrphq52jdkgwWDydgA@mail.gmail.com>
References: <480d3e9c-a7b0-46c7-6744-6aa5b4a75635@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36421 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935095AbdLRSXX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Dec 2017 13:23:23 -0500
Received: by mail-qk0-f178.google.com with SMTP id 8so19473108qkj.3
        for <linux-bcache@vger.kernel.org>; Mon, 18 Dec 2017 10:23:23 -0800 (PST)
In-Reply-To: <480d3e9c-a7b0-46c7-6744-6aa5b4a75635@nuclearwinter.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

Hi Larkin--

On Mon, Dec 18, 2017 at 9:37 AM, Larkin Lowrey
<llowrey@nuclearwinter.com> wrote:
> I'm noticing that, with Fedora, dracut is trying to stop the mdraid devices
> before bcache stops.
>
> I haven't seen any data loss or corruption so this doesn't seem to be a
> problem but it would be nice to have bcache stop first so I don't get so
> alarmed by these messages.

Well, plus, it'd be nice to properly stop md, else there's a chance
you end up scrubbing volumes when you don't need to, etc.

> How is the shutdown sequence for bcache controlled? Where can I find the
> relevant code?

All of that, unfortunately, is details maintained by your
distribution.  And this is a tricky problem-- note some people build
md-on-bcache instead of bcache-on-md (I prefer the latter), and the
shutdown order would be correct for the former.

Mike
