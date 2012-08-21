From: Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Issues dropping vm fs caches with kernel 3.5.2 + bcache master
Date: Tue, 21 Aug 2012 02:31:18 +0200
Message-ID: <CAAnFQG_rE9f61Rgo+xH6uNujLwNx_QFaF-OpH_=pYro-+99AFQ@mail.gmail.com>
References: <CAAnFQG9JCMpZ7VSnuNxSGxXa4KrDWjdP4e3UJZj=W2Jbi30dZg@mail.gmail.com>
 <20120820202921.GA21953@google.com> <CAAnFQG-aK4aR8J05oe=MygbzjkoW4furOSyEjrhw6Zp0vznhEw@mail.gmail.com>
 <20120821001514.GB21953@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120821001514.GB21953-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux BCache Mailing List <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

>> >> I've recently set up a software RAID5 + bcache.
>> >>
>> >> I'm using kernel 3.5.2 merged with bcache master branch. I'm quite
>> >> happy with the performance but
>> >> there is an important issue. I can't drop caches. Writing any number
>> >> to /proc/sys/vm/drop_caches
>> >> makes the system hung.
>> >>
>> >> Furthermore, so far I've been unable to curb bcache's memory
>> >> consumption using the available
>> >> sysctl knobs.
>> >>
>> >> Is this problem known?
>> >
>> > No I didn't know about that - thanks, I'll look into it.
>
> Just tried it - I can reproduce it, but it's gone in 3.6. Looks like a
> 3.5 bug, not a bcache bug.

Oh, it was a coincidence then. I hadn't needed to use that for a long
time.

> I'm gonna reset the master branch to my current dev branch soon as I've
> tested it a bit more, but I'd suggest the bcache-3.2 branch - that's the
> best tested code.

I cannot use a 3.2 kernel. This an HTPC too, besides a NAS and host for
vm guests. The tuners I have are supported from 3.4 onwards.

Do you mean there might be more problems with the master branch?

By the way. I have read in the manual how to add new cache devices, but
can you remove completely the caches in a 'clean way'? Imagine to change
it to a different disk which for some reason you cannot use at the same time.


-- 
Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
