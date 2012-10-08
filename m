From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Mon, 8 Oct 2012 16:39:03 +0000 (UTC)
Message-ID: <loom.20121008T172856-174@post.gmane.org>
References: <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com> <loom.20120928T010314-562@post.gmane.org> <20120928185949.GA7062@google.com> <loom.20121001T211315-779@post.gmane.org> <20121001193806.GA26488@google.com> <loom.20121001T220412-225@post.gmane.org> <20121001203706.GB26488@google.com> <loom.20121001T223817-249@post.gmane.org> <20121001211458.GC26488@google.com> <loom.20121002T001556-394@post.gmane.org> <20121001230023.GG26488@google.com> <CAH+dOx+Xju7-OFbJevrs3M3pXACzt_a+2T9Mqiuh6gLLyPksMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <koverstreet@...> writes:

> 
> Man, this is a frustrating issue :)
> 
> I haven't been able to come up with a way of fixing it right without
> rewriting a bunch of code. I do have a workaround figured out though
> if this is a real issue for you - it'll just increase internal
> fragmentation in the btree a bit, but with large btree nodes like you
> normally want not enough to matter.
> 
> Though like I said, as long as your workload isn't 100% reads this
> shouldn't be an isuse.
> 

Sorry to be away for a few days.

I can imagine it is frustrating. I've been looking at the code and it seems
pretty tough.

I think it would be worthwhile to have this fixed if possible as it does benefit
small caches (i.e. 1GB in size) as well.

Basically, I made my combination of reads verses writes to be 99 to 1 like you
said to do. So 99% of the time, I'm doing a read. When I do this, I never see my
IOPS rate get over approximately 45K.

Also previously, when I run my test over a 1GB region with 100% reads, once the
cache warmed, I would see 0.350ms response time for a read. Once I changed the
read/write mixture to 99% reads, the response time went down to 0.150ms. So I
would think it would be beneficial to small workloads and large workloads if we
could fix this.

I'm happy to test this for you or help out in any way possible.

Thanks.

-brad w.
