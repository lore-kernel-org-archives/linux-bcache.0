From: Thierry De Leeuw <deleeuw.thierry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bad btree header at bucket xxx.
Date: Sun, 10 Nov 2013 16:16:43 +0100
Message-ID: <1A247FB8-5C48-43A8-AE2D-4099C9900C73@gmail.com>
References: <5276DE9D.6000401@de-leeuw.org> <527E1063.4090209@rolffokkens.nl> <527E31DF.5080204@de-leeuw.org> <527F5B57.1020400@rolffokkens.nl>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527F5B57.1020400-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: Thierry De Leeuw <thierry-gY9mk9TZ+INg9hUCZPvPmw@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Rolf

Thanks for the info. I will still wait a bit for Kent or Gabriel to tell if and what info they are interested in (or maybe say that I can drop and recreate the device)

Is there any chance that some data is still in the cache that could be recovered?

Maybe an emergency tool that tries to read the data and apply it before restarting the devices could be useful.

Thanks again for your reply much appreciated!

Thierry

> On 10 nov. 2013, at 11:09, Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org> wrote:
> 
>> On 11/09/2013 02:00 PM, Thierry De Leeuw wrote:
>> Hi Rolf,
>> 
>> Thanks for your answer. Do you know of a specific commit that was made
>> to fix that issue or it just did not appear anymore? How frequently did
>> you encoutner this issue?
> I ran into this once, but haven't had this issue since. I can't recall a specific commit, but I think it was kernel 3.11.4.
>> I also thought of just reformatting the cache, but I would remove all
>> evidences/traces that could maybe be useful to investigate the issue. So
>> if I have no-one interested in some post morten on the cache device in
>> the coming days, I will proceed with that approach.
>> There is also little tooling to trace, investigate or fix problems
>> apparently. Is it something planned in the future?
>> 
>> What is also odd to me is that the GUID listed in dmesg does not seem to
>> match any device (eventhough it is clear that the message is about the
>> cache device sdb1)
> When I ran into this issue I was mosty interested in recovering from a "broken caching device" which showed not to be that hard. I assumed I could gather more evidence if the issue would show up again. I can imagine Kent or Gabriel could be interested in some post-mortem analysis, but that's up to them.
> 
> Rolf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
