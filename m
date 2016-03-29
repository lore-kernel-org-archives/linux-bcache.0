From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Testing bcachefs - beginners questions
Date: Tue, 29 Mar 2016 21:10:18 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603292107280.13440@mail.ewheeler.net>
References: <20160318041551.GA7889@kmo-pixel> <alpine.LRH.2.11.1603181857450.16487@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:53190 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753968AbcC2VKV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Mar 2016 17:10:21 -0400
In-Reply-To: <alpine.LRH.2.11.1603181857450.16487@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

On Fri, 18 Mar 2016, Eric Wheeler wrote:

> On Thu, 17 Mar 2016, Kent Overstreet wrote:
> > since the announcement. I'm gonna have to write some more documentation and do
> > another announcement soon.
> > 
> > One thing to note if you're running benchmarks is that data checksumming is on
> > by default - it doesn't hurt most stuff noticably, but small random reads where
> > your read size is smaller than the checksum granularity (typically the size of
> > the writes you issued) will suck because it'll have to bounce and read the
> > entire chunk of data the checksum covered.
> > 
> > Benchmark wise, here's a dio append benchmark I ran the other day:
> > 
> > Summary:
> > bcachefs:       1749.1 MB/s
> > ext4:           513.6 MB/s
> > xfs:            515.7 MB/s
> > btrfs:          531.2 MB/s
> 
> Wow, that is incredible.  For an upper limit on the extX filesystem line, 
> would you run a benchmark on your hardware for ext2 or ext4 without 
> journal?

Hey Kent,

Have you had a chance to see how much faster bcache is compared to ext2 or 
ext4-no-journal on your hardware?  I'm curious about performance without 
journaling.

-Eric


--
Eric Wheeler
