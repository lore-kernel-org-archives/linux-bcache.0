From: Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Issues dropping vm fs caches with kernel 3.5.2 + bcache master
Date: Mon, 20 Aug 2012 23:06:30 +0200
Message-ID: <CAAnFQG-aK4aR8J05oe=MygbzjkoW4furOSyEjrhw6Zp0vznhEw@mail.gmail.com>
References: <CAAnFQG9JCMpZ7VSnuNxSGxXa4KrDWjdP4e3UJZj=W2Jbi30dZg@mail.gmail.com>
 <20120820202921.GA21953@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120820202921.GA21953-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux BCache Mailing List <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

>> I've recently set up a software RAID5 + bcache.
>>
>> I'm using kernel 3.5.2 merged with bcache master branch. I'm quite
>> happy with the performance but
>> there is an important issue. I can't drop caches. Writing any number
>> to /proc/sys/vm/drop_caches
>> makes the system hung.
>>
>> Furthermore, so far I've been unable to curb bcache's memory
>> consumption using the available
>> sysctl knobs.
>>
>> Is this problem known?
>
> No I didn't know about that - thanks, I'll look into it.

Thanks :)

> Just out of curiousity, what are you doing? drop_caches isn't something
> you want to use in normal operation...

Yeah, not normal operation, but this machine has 8 GB of ram and nearly 7
were being used by caches. I tried to launch a virtual machine and I couldn't.

Seeing the state the memory was in, I went off to drop the caches, and... hang.


-- 
Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
