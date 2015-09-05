From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Sat, 05 Sep 2015 13:06:57 +0200
Message-ID: <20150905130658.Horde.bdSqYx_a293KuFa5vdTuajm@www3.nde.ag>
References: <20150830085442.GA31722@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:19337 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbbIELHK (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 5 Sep 2015 07:07:10 -0400
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.11 AUTH)
	with ESMTPA id x016c7r85B77YMi
	for <linux-bcache@vger.kernel.org>;
	Sat, 5 Sep 2015 13:07:07 +0200 (CEST)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id C6CBA1C05C
	for <linux-bcache@vger.kernel.org>; Sat,  5 Sep 2015 13:06:57 +0200 (CEST)
In-Reply-To: <20150830085442.GA31722@suse.com>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all,

I've noticed similar oddities with our servers - not quite the same,  
but close enough so I won't open a new thread:

We're running kernel 3.18.8 on server machines delivering SAN and NAS  
resources. Back-end storage is a MD-RAID6 (7 WD Red 1TB 2,5"), cache is
on MD-RAID1 (2 SSD TOSHIBA PX02SMF020 200GB). As we live migrated from  
128GB SSDs to the Toshibas, the cache size is still at 128 GB.

On one of the servers, I noticed excessive I/O load reported by our  
monitoring tools. Having read this thread, I tried to get the amount  
of dirty data down (cache_mode set to "writeback", writeback_percent  
to 0, writeback_rate to 10000 and then monitoring  
writeback_rate_debug), but unlike with the other server, the amount of  
dirty data would not go below 186M. Unlike with the original report,  
bcache_writeback wasn't at 100% but varying in its CPU usage - but  
always on top of all other processes running. I/O wait was unusually  
high, compared to the amount of data written.

I left the system rest over night, to find that the next day it would  
not go below 197M, so that "bad spot" had changed. The load on this  
server had increased - looking at the stats, it seemed like writeback  
was trying to write data all the time, but for whatever reason failing  
(which matched the lower limit of dirty data).

Fearing the worst, I set the cache mode to writearound to disable  
further caching (amount of dirty still wouldn't drop below its border  
value), stopped the clients for this server and rebooted.

Luckily, the server came up without a problem, and *I now could get  
the amount of dirty data down to zero*. I switched back to writeback,  
with writeback_percent to 0 and a fixed writeback_rate.

So in our case, it looks like something borked in bcache's run-time,  
rather than on-disk (read: SSD cache content).

Regards,
Jens

PS: We're still facing random reboots (of unknown cause), which may  
correlate with bcache's "amount dirty" being near the limit set by  
writeback_percent. I'm trying to work-around this these days by  
running with writeback_percent set to zero and using a writeback_rate  
that lets the cache clean up over the day... so far, so good, but it's  
too early to tell for sure. Since switching to the new SSDs, the  
reboot rate went down to about once a week and I've made this change  
only two days ago.
