From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Bcachefs testing needed
Date: Sun, 6 Nov 2016 10:32:14 -0500
Message-ID: <16bf179c-6ed4-5f82-b95d-7a5a9c01d20b@gmail.com>
References: <20161105160502.5bknr5ufufzdyn3i@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35750 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbcKFPcW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 6 Nov 2016 10:32:22 -0500
Received: by mail-it0-f68.google.com with SMTP id f129so4883435itc.2
        for <linux-bcache@vger.kernel.org>; Sun, 06 Nov 2016 07:32:21 -0800 (PST)
In-Reply-To: <20161105160502.5bknr5ufufzdyn3i@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, chris@cooperteam.net, marcin@mejor.pl


On 11/05/2016 12:05 PM, Kent Overstreet wrote:
> Chris, Marcin, anyone else who wants to help out - the bcachefs-testing branch
> needs testing before I merge in those patches.
>
> Chris was seeing filesystem corruption with the foreground btree merging
> patches, and I still haven't figured out what that was (although I have fixed
> some possible culprits), so please don't run this on anything with real data
> until it's seen some more testing. This branch also doesn't have btree node
> merging yet - it's got the btree locking changes, and some new work making
> iterators more rigorous and tightening up invariants. Once we're sure that stuff
> is all good I'll push out btree node merging again.
>
> And I definitely could use more testers - testing is getting to be a significant
> bottleneck these days.

Last I checked, the bcachefs came as an entire specific kernel tree, and 
not patch(sets) against kernels.  I'd be looking to test against 4.4 and 
possibly 4.8, as we also have our own patches we need to apply and I 
don't want to rebase everything to test this.   Patches would definitely 
be easier for me to apply and test with.   4.4 is our current kernel, 
3.18 is our legacy, and 4.8 is our experimental.

Happy to try to generate a patch if you can tell me what tree you based 
it on.

FWIW:  We've got lots of kit we can test it against (large multi-disk 
servers, lots of SSD, etc.) in our lab.

-- 
Joe Landman
e: joe.landman@gmail.com
t: @hpcjoe
c: +1 734 612 4615
w: https://scalability.org
