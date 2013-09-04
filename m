From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] bcache: Fix a shrinker deadlock
Date: Wed, 4 Sep 2013 16:45:04 -0700
Message-ID: <20130904234504.GA2635@kmo-pixel>
References: <CAFkUHxd6xN3On4DTC7VnUgVuy8M57k=8eKYr47bKKnpQWS+p8A@mail.gmail.com>
 <20130830211510.GA20307@kmo-pixel>
 <CAFkUHxfYeF8G+r3RYp3dTaOBzPqo_diVoF5g_7sAeW+wKprrjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFkUHxfYeF8G+r3RYp3dTaOBzPqo_diVoF5g_7sAeW+wKprrjA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel neophyte <neophyte.hacker001@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefan Priebe <s.priebe@profihost.ag>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 04, 2013 at 04:35:50PM -0700, kernel neophyte wrote:
> On Fri, Aug 30, 2013 at 2:15 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> > GFP_NOIO means we could be getting called recursively - mca_alloc() ->
> > mca_data_alloc() - definitely can't use mutex_lock(bucket_lock) then.
> > Whoops.
> >
> > Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> 
> Awesome! I tested the fix... no crashes/deadlock.
> But I see lower benchmark numbers for random write.. is this expected
> for this change ?

No... how much lower?
