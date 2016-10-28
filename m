From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 18:55:06 +0200
Message-ID: <20161028165506.GA7233@suse.com>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com>
 <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
 <20161028130720.GA31703@suse.com>
 <20161028131310.4fi4vm54fgsl7nqg@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:56592 "EHLO
        jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934937AbcJ1QzK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 12:55:10 -0400
Content-Disposition: inline
In-Reply-To: <20161028131310.4fi4vm54fgsl7nqg@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: James Pharaoh <james@pharaoh.uk>, linux-bcache@vger.kernel.org

On Fri, Oct 28, 2016 at 05:13:10AM -0800, Kent Overstreet wrote:
> t
> On Fri, Oct 28, 2016 at 03:07:20PM +0200, Vojtech Pavlik wrote:
> > The only situation where data damage can happen is a power outage that
> > comes together with a loss of one of the drives. In such a case, the
> > content of any blocks written past the last barrier is undefined. It
> > then depends on the filesystem whether it can revert to the last sane
> > state. Not sure about others, but btrfs will do so.
> 
> It's not any data written since the last barrier - in a non COW filesystem,
> potentially the entire stripe is toast, which means existing unrelated data gets
> corrupted. There's nothing really a non COW filesystem can do about it.

Again, you're right, if a drive is lost during a power outage, there can
be damage even outside of the blocks that were written if plain data was
written and xor wasn't. I don't think there is a filesystem that can
handle damage to untouched data cleanly.

An additional journal that works closely with the RAID device and tracks
what has been written to all devices is required to close this remaining gap.

But then, if the journal device is lost during a power outage ... ;)

-- 
Vojtech Pavlik
Director SuSE Labs
