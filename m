From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bad btree header at bucket xxx.
Date: Sun, 10 Nov 2013 11:09:27 +0100
Message-ID: <527F5B57.1020400@rolffokkens.nl>
References: <5276DE9D.6000401@de-leeuw.org> <527E1063.4090209@rolffokkens.nl> <527E31DF.5080204@de-leeuw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527E31DF.5080204-gY9mk9TZ+INg9hUCZPvPmw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry De Leeuw <thierry-gY9mk9TZ+INg9hUCZPvPmw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 11/09/2013 02:00 PM, Thierry De Leeuw wrote:
> Hi Rolf,
>
> Thanks for your answer. Do you know of a specific commit that was made
> to fix that issue or it just did not appear anymore? How frequently did
> you encoutner this issue?
I ran into this once, but haven't had this issue since. I can't recall a 
specific commit, but I think it was kernel 3.11.4.
> I also thought of just reformatting the cache, but I would remove all
> evidences/traces that could maybe be useful to investigate the issue. So
> if I have no-one interested in some post morten on the cache device in
> the coming days, I will proceed with that approach.
> There is also little tooling to trace, investigate or fix problems
> apparently. Is it something planned in the future?
>
> What is also odd to me is that the GUID listed in dmesg does not seem to
> match any device (eventhough it is clear that the message is about the
> cache device sdb1)
When I ran into this issue I was mosty interested in recovering from a 
"broken caching device" which showed not to be that hard. I assumed I 
could gather more evidence if the issue would show up again. I can 
imagine Kent or Gabriel could be interested in some post-mortem 
analysis, but that's up to them.

Rolf
