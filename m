From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: Fix writeback_thread never writing back
 incomplete stripes.
Date: Thu, 17 Sep 2015 08:40:54 -0800
Message-ID: <20150917164054.GA28032@kmo-pixel>
References: <20150905111012.GA17180@suse.com>
 <20150916113206.GA16164@kmo-pixel>
 <CAO2mnozhTeuWwxsmQZor93xmyS5_r34YpGXy0ec=9vFCBGbO1w@mail.gmail.com>
 <CAO2mnowurDEfqaZZk6MLmCtTFJ4MkgGEG9DKYytwkDSv1W4dnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO2mnowurDEfqaZZk6MLmCtTFJ4MkgGEG9DKYytwkDSv1W4dnQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Bychkov <manover@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Emmanuel Florac <eflorac@intellique.com>, Jiri Kosina <jkosina@suse.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-bcache@vger.kernel.org

On Thu, Sep 17, 2015 at 11:30:17AM -0400, Denis Bychkov wrote:
> Well, it turns out my celebration was a bit premature.
> 
> PLEASE, DO NOT APPLY THE PATCH POSTED BY KENT (not the one Vojtech
> posted) ON A PRODUCTION SYSTEM, IT CAUSES DATA CORRUPTION.
> 
> The interesting thing is that it somehow damaged the partition that
> was not supposed to receive any writes (the file system was mounted
> read-only), so my guess is that the patch causes the blocks residing
> in the write-back cache to flush to the wrong blocks on the backing
> device.
> Everything was going great until I rebooted and saw this in the log:
> 
> [   19.639082] attempt to access beyond end of device
> [   19.643984] md1p2: rw=1, want=75497520, limit=62914560
> [   19.659033] attempt to access beyond end of device
> [   19.663929] md1p2: rw=1, want=75497624, limit=62914560
> [   19.669447] attempt to access beyond end of device
> [   19.674338] md1p2: rw=1, want=75497752, limit=62914560
> [   19.679195] attempt to access beyond end of device
> [   19.679199] md1p2: rw=1, want=75498080, limit=62914560
> [   19.689007] attempt to access beyond end of device
> [   19.689011] md1p2: rw=1, want=75563376, limit=62914560
> [   19.699055] attempt to access beyond end of device
> [   19.699059] md1p2: rw=1, want=79691816, limit=62914560
> [   19.719246] attempt to access beyond end of device
> [   19.724144] md1p2: rw=1, want=79691928, limit=62914560
> ......
> (it's a small example, the list was much longer)
> And the next thing I found out the super block on my 10-Tb XFS RAID was gone. :)
> Oh well, it's a good thing I have backups.
> I knew what I was doing when trying the untested patches. I should
> have made the RAID md partition read-only, not the file system. I kind
> of expected that something could have gone wrong with the file system
> I was testing, just did not expect it would fire nukes at the innocent
> bystanders.

Aw, shit. That's just _bizzare_.

I have a theory - it appears that last_scanned isn't getting initialized before
it's used, so it's going to be all 0s the very first time... which it appears
could cause it to slurp up keys from the wrong device (and if that device was
bigger than the correct device, that could explain the accesses beyond the end
of the device).

Currently just a theory though, and I have no clue why it would only be exposed
with my patch.
