From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache on top of drbd or the contrary?
Date: Mon, 3 Jun 2013 12:14:57 -0700
Message-ID: <20130603191457.GJ2291@google.com>
References: <CAAxY4JkxnNqe_AUjERze30t8GQSD_3ZXXgM84Q+O_bnP6TCs4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAxY4JkxnNqe_AUjERze30t8GQSD_3ZXXgM84Q+O_bnP6TCs4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Giovanni Lenzi <giovanni.lenzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sat, Jun 01, 2013 at 05:45:09PM +0200, Giovanni Lenzi wrote:
> Hi,
> I'm planning to user bcache for speed, and drbd for HA between two nodes.
> 
> I'm facing with this question:
> Is it better to have drbd on top of a bcached volume(caching + backing device)
> or to use bcache to put a caching device on top of a drbd backing device?
> 
> I think that with the second option and writeback enabled, write
> requests should be faster than with the first option... Do you agree?
> 
> But.. what about the data integrity and consistency of the data on the
> drbd slave volume? What if the power goes down on the master node?
> Could the drbd volume on the slave node, get corrupted If the caching
> device is not detached correctly on the master node?
> 
> On the contrary with the first option(drbd on top of bcache), I think
> drbd should always preserve data integrity on the two nodes, isn't it?
> Can bcache with writeback mode, cause corrupted data on both nodes in
> case of a ssd, or power unit failure?
> 
> And where is it better to put drbd metadata? External or internal?
> External to ssd is the obvious answer, but if I want to store them
> internally, what will be the advantages and disadvantages of the two
> solutions?
> 
> With the first option, storing metadata internally on the bcached
> device should not be so slow, given that bcache should always cache
> most used data. Isn't it?
> 
> What do you think about this subject?

If you're using bcache in writethrough mode, running bcache on top of
drbd is fine and may be faster (but benchmark it if you care).

Reason being in writethrough mode the SSD failing won't hurt anything.

If you're using bcache in writeback mode, _definitely_ run drbd on top
of bcache.

In writeback mode, if the SSD fails the backing device is now useless.
If you were using bcache under drbd, no big deal - you have a replica of
the backing device. If you're using bcache on top of drbd... well,
that's /dev/drbd0 that's now toast, and you're screwed.
