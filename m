From: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Subject: Re: bcache hangs with continuous write I/O to SSD device, bcache
 device stops working
Date: Fri, 22 Mar 2013 15:19:40 +0100
Message-ID: <514C687C.4010304@modelnine.org>
References: <514C4FC1.6090804@modelnine.org> <20130322141613.GA29496@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130322141613.GA29496-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Am 22.03.2013 15:16, schrieb Dongsu Park:
> that sounds pretty much the same as what I experienced this week.
> After finishing some write benchmarks on a bcache device, dirty data
> blocks have to be synchronized to backing devices really slowly.
> (20~30 MB/s in my case)
> That sync job usually takes more than 5 minutes,
> which makes end users unable to do anything.

In my case, the syncing was still going on after around 16 hours (I 
simply let the system run after it got locked in this state). As I've 
only got around 2GB of page cache in the corresponding system that was 
used as the test bed, most probably, the system wasn't (still) flushing 
data, but rather spinning on something else.

The process that took most CPU time was a kworker, which migrated 
between CPUs. If there's any sensible way to debug this (without 
availability of a serial console, alas...), I'd appreciate any hints.

-- 
--- Heiko.
