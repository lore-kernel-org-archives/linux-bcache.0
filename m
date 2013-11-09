From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bad btree header at bucket xxx.
Date: Sat, 09 Nov 2013 11:37:23 +0100
Message-ID: <527E1063.4090209@rolffokkens.nl>
References: <5276DE9D.6000401@de-leeuw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5276DE9D.6000401-gY9mk9TZ+INg9hUCZPvPmw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry <thierry-gY9mk9TZ+INg9hUCZPvPmw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 11/04/2013 12:39 AM, Thierry wrote:
> After a reboot, the bcache devices didn't appeared. Looking at dmesg I
> foud out the following entries:
> [ 12.182288] bcache: register_bdev() registered backing device dm-0
> [ 12.217379] bcache: register_bdev() registered backing device dm-1
> [ 12.253040] bcache: error on d8e791cc-47c2-449c-909a-1e4433a5de11: bad
> btree header at bucket 32018, block 0, 0 keys, disabling caching
> [ 12.253050] bcache: register_cache() registered cache device sdb1
> [ 12.253488] bcache: cache_set_free() Cache set
> d8e791cc-47c2-449c-909a-1e4433a5de11 unregistered
>
> As you see I restarted the devices after having changed the cache mode
> to "none" followed by a echo 1 > running (The state of the 2 devices
> were dirty)
> e2fsck do not report any problem on any of the bcache device
>
> Are there other "emegency actions" I should take (cache is till reported
> as inconsistent)?
I've seen the same problems in earlier kernels, but not in kernels > 3.11.5.

After also forcing the bcache device to running (echo 1 > running) I 
also recreated the caching device (make-bcache -C ...) and reattached it 
to the bcache device. Have you tried to do that?

Rolf
