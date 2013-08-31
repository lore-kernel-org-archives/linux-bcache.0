From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] bcache: Fix a shrinker deadlock
Date: Fri, 30 Aug 2013 22:20:18 -0600
Message-ID: <20130831042018.GP21481@kernel.dk>
References: <CAFkUHxd6xN3On4DTC7VnUgVuy8M57k=8eKYr47bKKnpQWS+p8A@mail.gmail.com>
 <20130830211510.GA20307@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130830211510.GA20307@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: kernel neophyte <neophyte.hacker001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stefan Priebe <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Fri, Aug 30 2013, Kent Overstreet wrote:
> GFP_NOIO means we could be getting called recursively - mca_alloc() ->
> mca_data_alloc() - definitely can't use mutex_lock(bucket_lock) then.
> Whoops.

Kent, can you provide and updated repo with the pending patches? There's
been some churn here lately (and good fixes), would like to ensure I
don't miss anything.

-- 
Jens Axboe
