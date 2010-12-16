From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: comparison with rival projects
Date: Wed, 15 Dec 2010 16:45:51 -0800
Message-ID: <4D09613F.4090600@gmail.com>
References: <1822941381.28401292455616547.JavaMail.root@shiva> <4D0957B4.6060801@gmail.com> <AANLkTi=hos1PdNJeRfi8mOxN9whosK+6cEfBpkv38coK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=hos1PdNJeRfi8mOxN9whosK+6cEfBpkv38coK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, inf-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 12/15/2010 04:18 PM, Nauman Rafique wrote:
> Kent, now that we are on the topic, I wonder if there has been some
> benchmarking comparing bcache to flashcache performance?

The only comparison I know of has been on MySQL performance, measured 
with sysbench - but flashcache was written specifically for mysql so I 
think that's fair.

With an X25-E, Flashcache was getting - if memory serves - around 160 
transactions per second. After enough runs bcache stabilizes at 220-230 
tps (starts out a bit higher, 250-260). Running off just the SSD gets 
around 290.

I got to test a bit on an ioDrive (I'll have my own soon and plan on 
testing more and posting benchmarks when I have it) - bcache was getting 
a pretty consistent 600 tps, with just the ioDrive it started out at 750 
tps and looked like it was stabilizing at ~680 tps. I haven't tried 
flashcache on that hardware, though.

>
> Also I wonder if you plan to target for getting bcache included in
> mainline kernel. I wonder if such attempts were made for flashcache
> but that's probably off-topic.

I am, I've just been chipping away at the todo list to get it ready to 
submit. I was just reworking my bio splitting code to not depend on some 
changes to the generic block layer - that was a big one, but I'm almost 
finished debugging that code.

Besides that, the next thing is adding and testing with fault injection, 
and making memory allocation deadlock proof; that should keep me busy 
for a bit. The main thing though is going to be figuring out what to do 
about the hooks in the block layer bcache is using; I don't expect nor 
want that code to be merged but I'm loathe to give up that functionality.

When thin provisioning/volume management is added those hooks won't be 
necessary, if you're not transparently caching an existing device - so 
what could conceivably happen is the transparent caching functionality 
never gets merged and the mainline version just has bcache managed 
backing devices. The other alternative could be using device mapper for 
transparently hooking in to existing block devices... which would still 
mean a loss of functionality, but it'd probably be less code to write 
and a shorter path to mainline.

I've been planning on pinging various other devs and asking what they 
think once I've got the code synced up to mainline - I'm still working 
off 2.6.35, I plan on resyncing with the latest stable once I've got 
some of the fault injection work done, hopefully not too much longer. 
Timeframe will be dependent on how the funding situation works out :)
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
