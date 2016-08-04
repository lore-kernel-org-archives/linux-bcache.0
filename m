From: Eric Wheeler <lists@ewheeler.net>
Subject: Re: every boot gives: bcache/alloc.c:78 WARNING
Date: Wed, 3 Aug 2016 17:26:30 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608031707300.10662@mail.ewheeler.net>
References: <20160803231919.GA13477@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:50460 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755312AbcHDAaA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 3 Aug 2016 20:30:00 -0400
In-Reply-To: <20160803231919.GA13477@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Wed, 3 Aug 2016, Marc MERLIN wrote:

> This happens on all kernels up to 4.7.
> Sorry, it happens earlier than ethernet coming up or my storage, so I can't
> use netconsole or other text dumps:
> https://goo.gl/photos/ubsi6maZXsjkevYY7
> 
> Looks like the warning happens on the registration of one of my bcache, but
> I can't tell which one or why.
> 
> Does the trace give any hints?
> (please ignore the load modules errors below, different issue)


Does it cause a problem, or just warn?

 73 uint8_t bch_inc_gen(struct cache *ca, struct bucket *b)
 74 {
 75         uint8_t ret = ++b->gen;
 76 
 77         ca->set->need_gc = max(ca->set->need_gc, bucket_gc_gen(b));
 78         WARN_ON_ONCE(ca->set->need_gc > BUCKET_GC_GEN_MAX);
 79 
 80         return ret;
 81 }

It looks like something needs garbage collected but perhaps isn't.  

You could write to sysfs/.../trigger_gc:
 
https://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt
	trigger_gc
	  Writing to this file forces garbage collection to run.

If that doesn't work, I wonder what increasing BUCKET_GC_GEN_MAX would do, 
though I don't know if that is safe.  Its set to 96U, so its not on on a 
bit boundary which sounds like it could be slightly safer---but I wouldn't 
try it unless this is a test machine.


--
Eric Wheeler


> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
