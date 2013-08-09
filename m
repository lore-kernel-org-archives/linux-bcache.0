From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: Converting existing partition to bcache backing device without
 loss of data
Date: Thu, 08 Aug 2013 19:29:33 -0500
Message-ID: <520437ED.9010004@warr.net>
References: <CAO9TOLddUrQCSchv_2-Xf=xjp_AOfN+NyePMPfiQYwqA+gx4ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO9TOLddUrQCSchv_2-Xf=xjp_AOfN+NyePMPfiQYwqA+gx4ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


On 08/08/2013 11:27 AM, Adam Brenner wrote:
> Howdy,
>
> I am in the process of testing bcache on our HPC cluster to act as
> cache for our gluster storage (~750TB).
>
> I notice that during the setup process on our test cluster, our
> backing device (where all our data is stored) will need to be
> formatted in order to support bcache.
You can't convert an in use block device into a backing store. 

Your best bet is to replace your gluster bricks either one at a time or
in acceptable groups with bricks that are bcache backed.

But without knowing more about how your gluster setup is architect-ed
this is just a guess.
> Does a way exist so we do not have to format our backing device? Or is
> working being done to support this?
In your particular case converting in place is not likely a very good
method even if it were supported.  Gluster is designed to be flexible in
such a way that you can replace existing storage bricks with new and
improved bcache backed bricks by simply replacing a replica in a set.
>
> Thanks,
> -Adam
>
> --
> Adam Brenner
> Computer Science, Undergraduate Student
> Donald Bren School of Information and Computer Sciences
>
> Research Computing Support
> Office of Information Technology
> http://www.oit.uci.edu/rcs/
>
> University of California, Irvine
> www.ics.uci.edu/~aebrenne/
> aebrenne-sXc7qaQca9o@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
