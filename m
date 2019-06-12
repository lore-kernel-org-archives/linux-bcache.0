From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
Date: Tue, 11 Jun 2019 16:07:40 -1000
Message-ID: <CAHk-=wgBdTUvjYXKPr_wAAe_Z-hFgM2KMHcsK+b=3w5yMSJ9zw@mail.gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611041045.GA14363@dread.disaster.area> <CAHk-=whDmeozRHUO0qM+2OeGw+=dkcjwGdsvms-x5Dz4y7Tzcw@mail.gmail.com>
 <20190611071038.GC14363@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190611071038.GC14363@dread.disaster.area>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 9:11 PM Dave Chinner <david@fromorbit.com> wrote:
>
> The same rwsem issues were seen on the mmap_sem, the shrinker rwsem,
> in a couple of device drivers, and so on. i.e. This isn't an XFS
> issue I'm raising here - I'm raising a concern about the lack of
> validation of core infrastructure and it's suitability for
> functionality extensions.

I haven't actually seen the reports.

That said, I do think this should be improving. The random
architecture-specific code is largely going away, and we'll have a
unified rwsem.

It might obviously cause some pain initially, but I think long-term we
should be much better off, at least avoiding the "on particular
configurations" issue..

              Linus
