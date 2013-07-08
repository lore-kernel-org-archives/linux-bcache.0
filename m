From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: reverse link from bucket to keys
Date: Mon, 8 Jul 2013 14:48:59 -0700
Message-ID: <20130708214859.GB1959@kmo-pixel>
References: <CAB7xdi=zBrOfPH9PwCeu=wrguku5utMXJM1pQFiRa1GZU6xGEw@mail.gmail.com>
 <CALJ65zk1kkUgOa4iqAFkA+64eU+6cEa=HRNQxZQ5SOwn4e5jAA@mail.gmail.com>
 <CAB7xdikiVCeG=fJENSGY2K256CGOZrp=MYE8q6quSGX0h=ph9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAB7xdikiVCeG=fJENSGY2K256CGOZrp=MYE8q6quSGX0h=ph9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sheng qiu <herbert1984106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Jul 08, 2013 at 09:44:41AM -0400, sheng qiu wrote:
> Hi Kent,
> 
> Thanks a lot for your reply.
> 
> Then i have a question about the bucket invalidation. when bcache
> choose to replace a bucket, will the keys that reside on that bucket
> still be in the btree? since you do not have information about which
> keys reside on the bucket, how do you update the btree?
> 
> i can think out two ways, one is you periodically scan the btree nodes
> and delete the stale nodes, the other way is when you get a cache hit
> on stale nodes, then you delete it at that moment. How bcache does
> this? Can you tell me the functions involve for these operations? i am
> interested in this part of codes.

This is documented in the code - start here:
http://evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/bcache.h?h=bcache-dev
