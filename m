From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: code stability (production readiness) and kernel versions
Date: Fri, 20 Apr 2012 23:51:58 +0800
Message-ID: <2E02F577-5903-4879-AD3D-043268366569@fnarfbargle.com>
References: <CAPwaGKZi1MTU03X+eam4Nm7K_RoTaQQVqzbLFLsN3xWvpMn-1g@mail.gmail.com> <CAH+dOxJMd_tObU8_y-o1irQFur=ooSt03=jVJoX7yDLSvzoOdw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxJMd_tObU8_y-o1irQFur=ooSt03=jVJoX7yDLSvzoOdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexandru Ionica <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> 
On 17/04/2012, at 4:30 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> 
> 
>> Also ... do you think that your code is production ready when using bcache
>> to do writeback caching ? Of course I will keep testing but I'd like to
>> know if you think the code by now is production ready.
> 
> Yeah, it is. Test it on your configuration, etc. etc. but writeback is
> pretty mature and well tested at this point.
> 
I've been giving serious thought to using this in a production environment. It performs well in my staging system, but my biggest concern revolves around the ultimate reliability of the ssd. 

How much testing have you performed with regard to cache device failures in a writeback scenario? I like the idea of mirroring the cache devices to replicate dirty data, however I know that is not implemented yet. 

We run a raid10 of SAS cheetahs. I'd love to mount a cache in there, but ultimately we have little information about what happens if the ssd starts to flake out. I guess more than that, there is little real information out there detailing common or potential ssd failure modes.

I'd assume you've performed plenty of testing over the development of bcache. Can you fill us in a bit as to what to expect when things go south?

Regards,
Brad--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
