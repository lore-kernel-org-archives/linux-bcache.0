From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [GIT PULL] bcache changes for 3.13
Date: Mon, 04 Nov 2013 13:12:17 -0700
Message-ID: <5277FFA1.6060001@kernel.dk>
References: <20131104200747.GD27129@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131104200747.GD27129@kmo>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 11/04/2013 01:07 PM, Kent Overstreet wrote:
> Hey Jens, sorry for being late with this - anyways, it's roughly the same set of
> patches you had queued up before plus a few minor fixes, but it's been rebased
> onto your for-3.13/core branch.

Merge window is a little later this time, and since it was already in
for the previous release, we can make it happen.

But can you please base it on for-3.13/drivers however? That's where I'd
like to pull in the driver bits, and if I pull this one, then things get
even more tangled since for-3.13/core is holding the blk-mq changes too.

-- 
Jens Axboe
