From: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Subject: Re: bcache hangs on writes, recovers after disabling discard on
 cache device
Date: Thu, 11 Jul 2013 17:58:17 +0300 (EEST)
Message-ID: <alpine.DEB.2.02.1307111748130.26927@orbit.lan>
References: <51C891C9.4060809@modelnine.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C891C9.4060809-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, 24 Jun 2013, Heiko Wundram wrote:

> In a rather old thread of mine (514C4FC1.6090804-EqIAFqbRPK3NLxjTenLetw@public.gmane.org), I already 
> stated a problem I was seeing back at the time, namely that bcache seems to 
> hang on writes to the SSD device after some time, writing 50 MB/s continuously 
> to the output device.
...
> Disabling discard on the SSD device (by echo 0 > 
> /sys/fs/bcache/.../cache0/discard) makes the bcache device become responsive 
> again.

I can confirm this. On Monday I booted into kernel 3.8.13-gentoo with the 
current "bcache" branch patched onto it. Discard was on for the cache 
device, and today this 50MB/s hang occured. Disabling discard did indeed 
fix it.

I had CONFIG_BCACHE_CLOSURES_DEBUG=y in the kernel, and the contents of 
/sys/kernel/debug/bcache/bcache-UUID and /sys/kernel/debug/closures both 
before and after disabling discard can be found at the address below, in 
case they can help in determining where exactly the hang happens.

http://www.metsahovi.fi/~jha/bcache/
