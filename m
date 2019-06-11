From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
Date: Mon, 10 Jun 2019 18:55:15 -1000
Message-ID: <CAHk-=wizTF+NbMrSRG-bc-LyuT7PUJ1QRAR8q_anOd6mY+9Z4A@mail.gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com> <20190611011737.GA28701@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190611011737.GA28701@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 3:17 PM Kent Overstreet
<kent.overstreet@gmail.com> wrote:
>
>
> > Why does the regular page lock (at a finer granularity) not suffice?
>
> Because the lock needs to prevent pages from being _added_ to the page cache -
> to do it with a page granularity lock it'd have to be part of the radix tree,

No, I understand that part, but I still think we should be able to do
the locking per-page rather than over the whole mapping.

When doing dio, you need to iterate over old existing pages anyway in
that range (otherwise the "no _new_ pages" part is kind of pointless
when there are old pages there), so my gut feel is that you might as
well at that point also "poison" the range you are doin dio on. With
the xarray changes, we might be better at handling ranges. That was
one of the arguments for the xarrays over the old radix tree model,
after all.

And I think the dio code would ideally want to have a range-based lock
anyway, rather than one global one. No?

Anyway, don't get me wrong. I'm not entirely against a "stop adding
pages" model per-mapping if it's just fundamentally simpler and nobody
wants anything fancier. So I'm certainly open to it, assuming it
doesn't add any real overhead to the normal case.

But I *am* against it when it has ad-hoc locking and random
anti-recursion things.

So I'm with Dave on the "I hope we can avoid the recursive hacks" by
making better rules. Even if I disagree with him on the locking thing
- I'd rather put _more_stress on the standard locking and make sure it
really works, over having multiple similar locking models because they
don't trust each other.

               Linus
