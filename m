From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: make-bcache's bucket size and block size values are ignored
Date: Tue, 9 Apr 2013 15:54:15 -0400
Message-ID: <20130409195414.GA5680@redhat.com>
References: <20130409140735.GA3984@redhat.com>
 <20130409193521.GJ15749@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130409193521.GJ15749-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Apr 09 2013 at  3:35pm -0400,
Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Apr 09, 2013 at 10:07:36AM -0400, Mike Snitzer wrote:
> > Hey Kent,
> > 
> > No matter what I specify via make-bcache's -b and -w args they are
> > always 512k and 512b respectively, e.g.:
> > 
> > # make-bcache -B /dev/mapper/test-dev-174467 -C /dev/mapper/test-dev-24832 --cache_replacement_policy=fifo -b 2048k --writeback --discard
> >     UUID:                       3705b1d8-4b44-406c-abf2-594c0cb146be
> >     Set UUID:           a16dc554-c054-4a24-90fa-40f624e3a652
> >     nbuckets:           8192
> >     block_size:         1
> >     bucket_size:                1024
> >     nr_in_set:          1
> >     nr_this_dev:                0
> >     first_bucket:               1
> >     UUID:                       46a37bba-2582-4533-a95b-1eb29c71e53f
> >     Set UUID:           a16dc554-c054-4a24-90fa-40f624e3a652
> >     nbuckets:           512
> >     block_size:         1
> >     bucket_size:                1024
> >     nr_in_set:          1
> >     nr_this_dev:                0
> >     first_bucket:               1
> > 
> > # cat /sys/block/bcache3/bcache/cache/bucket_size 
> > 512k
> > 
> > I can take a look at the make-bcache source in a bit but figured I'd let
> > you know sooner rather than later.
> 
> Oh, it's because you specified the bucket size after the device. If you
> specify the devices last it'll work.
> 
> So it's definitely unintuitive and semi broken, the reason it works that
> way is for formatting backing devices and cache devices at the same
> time; it walks through the options, and when it sees a device it formats
> it with the options seen so far.

OK, thanks for the insight.

> Right way to do it would be to make two passes... 

Or just defer the formatting until all args are processed.

> I suppose I should just do that so it doesn't trip other people up.

Yeah, probably for the best.

Thanks.
