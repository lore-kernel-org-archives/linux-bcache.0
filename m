From: Greg Bowyer <gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
Subject: Re: New stuff up in git
Date: Fri, 09 Sep 2011 14:46:39 -0700
Message-ID: <j4d5bv$v1b$1@dough.gmane.org>
References: <CAC7rs0tjhf73fRGE6rvVGjiCGc1coCAZTQNFqoC0iAn+YmGZng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0tjhf73fRGE6rvVGjiCGc1coCAZTQNFqoC0iAn+YmGZng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Sorry if this is a dumb question, is bcache-3.1 an update to bcache for 
kernels 3.1+

I ask because I dumbly merged bcache onto the v3.0 tag today since I 
want to have a play with bcache

On 08/09/11 01:49, Kent Overstreet wrote:
> I just finished updating both the bcache (off 2.6.34) and the
> bcache-3.1 branches with the latest stable code.
>
> Also got cgit set up and working, finally. Need to stick a link in the
> wiki to it..
>
> http://evilpiepirate.org/git
>
> I still haven't figured out how to pack a git repository so cloning it
> doesn't take>  80% of my linode's ram, but cloning works for me so I'm
> done screwing with it for now.
>
> The bcache branch compiles but hasn't been tested. I don't expect any
> issues though, it's pretty close to what I normally develop/test on.
>
> The bcache-3.1 branch still doesn't quite compile, but it's pretty
> close - I'm try and get a working version pushed tomorrow, I did boot
> a linux 3.1 + bcache kernel at one point...
