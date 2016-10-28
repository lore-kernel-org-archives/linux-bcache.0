From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 05:13:10 -0800
Message-ID: <20161028131310.4fi4vm54fgsl7nqg@kmo-pixel>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com>
 <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
 <20161028130720.GA31703@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36512 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbcJ1NNO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 09:13:14 -0400
Received: by mail-pf0-f175.google.com with SMTP id e6so37479518pfk.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Oct 2016 06:13:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20161028130720.GA31703@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: James Pharaoh <james@pharaoh.uk>, linux-bcache@vger.kernel.org

t
On Fri, Oct 28, 2016 at 03:07:20PM +0200, Vojtech Pavlik wrote:
> The only situation where data damage can happen is a power outage that
> comes together with a loss of one of the drives. In such a case, the
> content of any blocks written past the last barrier is undefined. It
> then depends on the filesystem whether it can revert to the last sane
> state. Not sure about others, but btrfs will do so.

It's not any data written since the last barrier - in a non COW filesystem,
potentially the entire stripe is toast, which means existing unrelated data gets
corrupted. There's nothing really a non COW filesystem can do about it.
