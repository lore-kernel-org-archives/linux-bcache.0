From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Thu, 27 Sep 2012 23:28:20 +0000 (UTC)
Message-ID: <loom.20120928T010314-562@post.gmane.org>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com> <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <koverstreet@...> writes:

> 
> Sounds like a good portion of your IO is bypassing the cache. That
> will happen if some of it's sequential, or if the SSD latency goes
> over a threshold - sequential_cutoff, congested_read_threshold_us and
> congest_write_threshold_us (if I'm remembering the names correctly)
> are the settings that control all that. 0 disables all of them.
> 

So I set the sequential_cutoff and congested_read_threshold_us to both be 0.
Since I was only doing reads, I figured there was no need to mess with the write
option.

But, I'm still seeing a problem. 

My hardware is:
1 - Dell PowerEdge R710 w/ 24 x Xeon processors, 96GB of ram
2 - Micron P320H SSD
3 - LSI storage device connected by a SAS interface

What I see is that when I do random reads over a 10GB region, the cache warms up
but hits a read response plateau at about 7ms. I still see a LOT (i.e. 32000
IOPS) of I/O to the disk. 

Yes, if I run the same test over a 1GB region, runs really fast. Pretty close to
the max IOPS rate of the SSD.

So I'm thinking there is a problem here or I have a bcache config issue.

I'm willing to try things but I need some guidance on what to look for as it
seems like a bcache issue.

Thanks for the help.

-brad w.
