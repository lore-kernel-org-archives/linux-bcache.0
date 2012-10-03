From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Tue, 2 Oct 2012 21:44:56 -0700
Message-ID: <CAH+dOx+Xju7-OFbJevrs3M3pXACzt_a+2T9Mqiuh6gLLyPksMg@mail.gmail.com>
References: <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com>
	<loom.20120928T010314-562@post.gmane.org>
	<20120928185949.GA7062@google.com>
	<loom.20121001T211315-779@post.gmane.org>
	<20121001193806.GA26488@google.com>
	<loom.20121001T220412-225@post.gmane.org>
	<20121001203706.GB26488@google.com>
	<loom.20121001T223817-249@post.gmane.org>
	<20121001211458.GC26488@google.com>
	<loom.20121002T001556-394@post.gmane.org>
	<20121001230023.GG26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001230023.GG26488-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Man, this is a frustrating issue :)

I haven't been able to come up with a way of fixing it right without
rewriting a bunch of code. I do have a workaround figured out though
if this is a real issue for you - it'll just increase internal
fragmentation in the btree a bit, but with large btree nodes like you
normally want not enough to matter.

Though like I said, as long as your workload isn't 100% reads this
shouldn't be an isuse.

On Mon, Oct 1, 2012 at 4:00 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Oct 01, 2012 at 10:26:43PM +0000, Brad Walker wrote:
>> Kent Overstreet <koverstreet@...> writes:
>>
>>
>> > I was just browsing around the code, and I bet I know what it is -
>> > btree_insert_check_key() is failing because the btree node is full.
>> >
>> > But, we should confirm this really is what's going on...  Can you apply
>> > this patch and rerun to test my theory? See if the number of times the
>> > printk fires lines up with the number of cache misses.
>> >
>>
>>
>> I applied this change and I see a LOT of the messages.
>>
>> And the rate seems to be increasing.
>
> Sweet, we know what it is then.
>
> So, like I mentioned this won't be an issue on any workload with mixed
> read/writes, so if that's what your production workloads are then this
> may not matter to you.
>
> For warming up the cache, doing a few random writes (just enough that
> you hit all the btree nodes - and there aren't many btree nodes, cat
> internel/btree_nodes) will fix it.
>
> A real fix for this shouldn't be too hard, but it's not exactly trivial
> and it'll be a pain to test... not quite sure when I'll get to it, but
> it would be good to have it fixed.
