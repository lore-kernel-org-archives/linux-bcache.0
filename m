From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Converting existing partition to bcache backing device without
 loss of data
Date: Thu, 8 Aug 2013 17:36:57 -0700
Message-ID: <20130809003657.GF15409@kmo-pixel>
References: <CAO9TOLddUrQCSchv_2-Xf=xjp_AOfN+NyePMPfiQYwqA+gx4ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO9TOLddUrQCSchv_2-Xf=xjp_AOfN+NyePMPfiQYwqA+gx4ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>, g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Aug 08, 2013 at 09:27:33AM -0700, Adam Brenner wrote:
> Howdy,
> 
> I am in the process of testing bcache on our HPC cluster to act as
> cache for our gluster storage (~750TB).
> 
> I notice that during the setup process on our test cluster, our
> backing device (where all our data is stored) will need to be
> formatted in order to support bcache.
> 
> Does a way exist so we do not have to format our backing device? Or is
> working being done to support this?

Unfortunately, there's no general purpose way - the faq explains why (I
just fixed the wiki so it's there again :)

http://bcache.evilpiepirate.org/FAQ/

However, Gabriel de Perthuis has a tool to do in place conversion - I
can't remember if it was limited to lvm devices or not - Gabriel, what
was the link to that again? I should stick a link to it in the wiki or
give you an account on it so you can.
