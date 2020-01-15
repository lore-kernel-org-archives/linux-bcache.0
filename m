From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
Date: Wed, 15 Jan 2020 14:21:05 +0800
Message-ID: <5af6593d-b6aa-74a7-0aae-e3c689cebc67@suse.de>
References: <20200104065802.113137-1-colyli@suse.de>
 <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
 <87lfqa2p4s.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87lfqa2p4s.fsf@esperi.org.uk>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2020/1/14 8:34 下午, Nix wrote:
> On 6 Jan 2020, Eric Wheeler spake thusly:
> 
>> On Sat, 4 Jan 2020, Coly Li wrote:
>>
>>> In year 2007 high performance SSD was still expensive, in order to
>>> save more space for real workload or meta data, the readahead I/Os
>>> for non-meta data was bypassed and not cached on SSD.
> 
> It's also because readahead data is more likely to be useless.
> 
>>> In now days, SSD price drops a lot and people can find larger size
>>> SSD with more comfortable price. It is unncessary to bypass normal
>>> readahead I/Os to save SSD space for now.
> 

Hi Nix,

> Doesn't this reduce the utility of the cache by polluting it with
> unnecessary content? It seems to me that we need at least a *litle*
> evidence that this change is beneficial. (I mean, it might be beneficial
> if on average the data that was read ahead is actually used.)
> 
> What happens to the cache hit rates when this change has been running
> for a while?
> 

I have two reports offline and directly to me, one is from an email
address of github and forwarded to me by Jens, one is from a China local
storage startup.

The first report complains the desktop-pc benchmark is about 50% down
and the root cause is located on commit b41c9b0 ("bcache: update
bio->bi_opf bypass/writeback REQ_ flag hints").

The second report complains their small file workload (mixed read and
write) has around 20%+ performance drop and the suspicious change is
also focused on the readahead restriction.

The second reporter verifies this patch and confirms the performance
issue has gone. I don't know who is the first report so no response so far.

I don't have exact hit rate number because the reporter does not provide
(BTW, because the readahead request is bypassed, I feel the hit rate
won't count on them indeed). But from the reports and one verification,
IMHO this change makes sense.

Thanks.

-- 

Coly Li
