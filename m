From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 03:52:49 -0800
Message-ID: <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33502 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754887AbcJ1Lwx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 07:52:53 -0400
Received: by mail-pf0-f182.google.com with SMTP id 197so36878411pfu.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Oct 2016 04:52:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20161026223158.GA9283@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: James Pharaoh <james@pharaoh.uk>, linux-bcache@vger.kernel.org

On Thu, Oct 27, 2016 at 12:31:58AM +0200, Vojtech Pavlik wrote:
> In case you're using mdraid for the RAID part on a reasonably recent
> Linux kernel, there is no write hole. Linux mdraid implements barriers
> properly even on RAID5, at the cost of performance - mdraid waits for a
> barrier to complete on all drives before submitting more i/o.

That's not what the raid 5 hole is. The raid 5 hole comes from the fact that
it's not possible to update the p/q blocks atomically with the data blocks, thus
there is a point in time when they are _inconsistent_ with the rest of the
stripe, and if used will lead to reconstructing incorrect data. There's no way
to fix this with just flushes.
