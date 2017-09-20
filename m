From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Writeback efficiency -- proposal
Date: Wed, 20 Sep 2017 01:51:23 -0700
Message-ID: <CAJ+L6qeCMtmJeN3oOD17qRzAOA3AbqxtzYAWobVj6Js1YXseMw@mail.gmail.com>
References: <CAJ+L6qe6=KTXFhss5rfa7g=UCMhp6wwCQ+qL_YZDJq+vWn=PNA@mail.gmail.com>
 <20170920080859.GA15880@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:46193 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdITIvZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Sep 2017 04:51:25 -0400
Received: by mail-qk0-f169.google.com with SMTP id z143so2042375qkb.3
        for <linux-bcache@vger.kernel.org>; Wed, 20 Sep 2017 01:51:24 -0700 (PDT)
In-Reply-To: <20170920080859.GA15880@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

Vojtech & Coly---

Thanks for feedback!

On Wed, Sep 20, 2017 at 1:08 AM, Vojtech Pavlik <vojtech@suse.com> wrote:
> On RAID devices, bcache attempts writing out full RAID stripes, avoiding
> the issue you describe.
>
> It might make sense to extend that logic to non-striped devices, too.

Yes-- it tries to write full stripes.  OTOH it doesn't favor
contiguous sets of full-stripes, and if there's not a lot of
full-stripes (500-- fairly unlikely, especially with sequential I/O
bypassing the cache) it falls back to the other behavior and will
happily pick the smallest blocks.  So it's still not seek minimized in
either case.

The data structure used for full-stripes would be not too bad to scan
to look for very large chunks.  I am not sure if we should, though, as
it is likely to destroy the LBA-ordering properties.  That is, there's
a definite tradeoff between trying to do the I/O in order and trying
to do the biggest I/Os.

For now I think I am going to put the heuristic in the fallback
(not-striped) case-- so on a striped array, first we'll search the
entire disk for full-stripes, then try to get bigger-than-average
reads, and finally fall back to anything we find on the way.

>> [snip]

> It doesn't sound wrong. :)
>
> Vojtech

Awesome.  :D I have some preliminary measurement that this is a win--
I'll work on getting a good patchset together some time in the next
week.

Thanks,

Mike
