From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] Bcache version 12
Date: Thu, 15 Sep 2011 15:03:08 -0700
Message-ID: <CAA9_cmdCg4UJrzYBzcrhD61PZ6hfrGWbF2A05LPo9WD55874uw@mail.gmail.com>
References: <20110910064531.GA32536@moria>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110910064531.GA32536@moria>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Sep 9, 2011 at 11:45 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> bcache, n.: a cache for arbitrary block devices that uses an SSD
>
> It's probably past time I started poking people to see about getting
> this stuff in. It's synced up with mainline, the documentation is for
> once relatively up to date, and it looks just about production ready.
>
> Suggestions are more than welcome on how to make it easier to review -
> it's entirely too much code, I know (near 10k lines now). I'll be
> emailing the patches that touch other parts of the kernel separately.
>
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself
> as a new block device, a bit like say md. You can cache an arbitrary
> number of block devices with a single cache device, and attach and
> detach things at runtime - it's quite flexible.
>
> It's very fast. It uses a b+ tree for the index, along with a journal to
> coalesce index updates, and a bunch of other cool tricks like auxiliary
> binary search trees with software floating point keys to avoid a bunch
> of random memory accesses when doing binary searches in the btree. It
> does over 50k iops doing 4k random /writes/ without breaking a sweat,
> and would do many times that if I had faster hardware.

Does it consider the raid5/6 write hole in what it caches?  Guess I
need to take a look at the code, but just wondering if it considers
the need to maintain a consistent strip when writing back to raid5/6
array, or would there still be a need for a separate driver/region of
the SSD for caching that data.
