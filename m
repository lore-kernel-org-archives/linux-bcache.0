From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
Date: Tue, 14 Jan 2020 12:34:11 +0000
Message-ID: <87lfqa2p4s.fsf@esperi.org.uk>
References: <20200104065802.113137-1-colyli@suse.de>
        <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net> (Eric
        Wheeler's message of "Mon, 6 Jan 2020 22:57:40 +0000 (UTC)")
Sender: stable-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 6 Jan 2020, Eric Wheeler spake thusly:

> On Sat, 4 Jan 2020, Coly Li wrote:
>
>> In year 2007 high performance SSD was still expensive, in order to
>> save more space for real workload or meta data, the readahead I/Os
>> for non-meta data was bypassed and not cached on SSD.

It's also because readahead data is more likely to be useless.

>> In now days, SSD price drops a lot and people can find larger size
>> SSD with more comfortable price. It is unncessary to bypass normal
>> readahead I/Os to save SSD space for now.

Doesn't this reduce the utility of the cache by polluting it with
unnecessary content? It seems to me that we need at least a *litle*
evidence that this change is beneficial. (I mean, it might be beneficial
if on average the data that was read ahead is actually used.)

What happens to the cache hit rates when this change has been running
for a while?
