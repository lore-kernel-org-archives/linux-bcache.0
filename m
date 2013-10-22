From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache not working on large files?
Date: Tue, 22 Oct 2013 15:16:21 -0700 (PDT)
Message-ID: <1382480181.33326.YahooMailNeo@web181504.mail.ne1.yahoo.com>
References: <20131022070830.GA20286@euve30603.vserver.de> <5266B774.6040202@rolffokkens.nl> <20131022180316.GA24473@euve30603.vserver.de> <1382476284.36900.YahooMailNeo@web181506.mail.ne1.yahoo.com>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382476284.36900.YahooMailNeo-XYahOdtEMNlRBbKmAC7my5OW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt

>
> When the SSD gets too slow it will get by-passed by bcache. The tunable is in 
> the document. Though if memory serves it's a latency of 20ms for writes 
> which is probably way too short since SSDs can easily take 1-5 seconds when they 
> have to resort to heavy lifting.


- Traffic's still going to the spindle/still getting cache misses In the real world, SSDs don't always keep up with disks - particularly with slower SSDs, many disks being cached by one SSD, or mostly sequential IO. So you want to avoid being bottlenecked by the SSD and having it slow everything down. To avoid that bcache tracks latency to the cache device, and gradually throttles traffic if the latency exceeds a threshold (it does this by cranking down the sequential bypass). You can disable this if you need to by setting the thresholds to 0: # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us 
