From: Thierry De Leeuw <thierry-gY9mk9TZ+INg9hUCZPvPmw@public.gmane.org>
Subject: Re: bad btree header at bucket xxx.
Date: Sat, 09 Nov 2013 14:00:15 +0100
Message-ID: <527E31DF.5080204@de-leeuw.org>
References: <5276DE9D.6000401@de-leeuw.org> <527E1063.4090209@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527E1063.4090209-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Rolf,

Thanks for your answer. Do you know of a specific commit that was made
to fix that issue or it just did not appear anymore? How frequently did
you encoutner this issue?

I also thought of just reformatting the cache, but I would remove all
evidences/traces that could maybe be useful to investigate the issue. So
if I have no-one interested in some post morten on the cache device in
the coming days, I will proceed with that approach.

There is also little tooling to trace, investigate or fix problems
apparently. Is it something planned in the future?

What is also odd to me is that the GUID listed in dmesg does not seem to
match any device (eventhough it is clear that the message is about the
cache device sdb1)

Thanks!

Thierry



On 11/09/2013 11:37 AM, Rolf Fokkens wrote:
> On 11/04/2013 12:39 AM, Thierry wrote:
>> After a reboot, the bcache devices didn't appeared. Looking at dmesg I
>> foud out the following entries:
>> [ 12.182288] bcache: register_bdev() registered backing device dm-0
>> [ 12.217379] bcache: register_bdev() registered backing device dm-1
>> [ 12.253040] bcache: error on d8e791cc-47c2-449c-909a-1e4433a5de11: bad
>> btree header at bucket 32018, block 0, 0 keys, disabling caching
>> [ 12.253050] bcache: register_cache() registered cache device sdb1
>> [ 12.253488] bcache: cache_set_free() Cache set
>> d8e791cc-47c2-449c-909a-1e4433a5de11 unregistered
>>
>> As you see I restarted the devices after having changed the cache mode
>> to "none" followed by a echo 1 > running (The state of the 2 devices
>> were dirty)
>> e2fsck do not report any problem on any of the bcache device
>>
>> Are there other "emegency actions" I should take (cache is till reported
>> as inconsistent)?
> I've seen the same problems in earlier kernels, but not in kernels >
> 3.11.5.
>
> After also forcing the bcache device to running (echo 1 > running) I
> also recreated the caching device (make-bcache -C ...) and reattached
> it to the bcache device. Have you tried to do that?
>
> Rolf
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
