From: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Subject: bcache on a laptop
Date: Thu, 19 Sep 2013 19:10:03 -0400
Message-ID: <523B844B.8070202@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Gents,

I'm still trying to get a comfy bcache installation on a laptop.  To 
summarize thus far,

     1. I have a Debian system that boots from bcache
     2. No version of 3.10 that I have tested (either from the Linux git 
or from the bcache-stable branch of the bcache git) will allow the 
laptop to sleep or hibernate properly.
     3. Every version of 3.11 that I have tested results in severe data 
corruption.  (I wound up having to reinstall my system as a result.)  
Using 3.11.0 built from the 3.11.y branch at kernel.org, the corruption 
was subtle at first; eventually programs started segfaulting.  Running 
"sync ; echo 3 > /proc/sys/vm/drop_caches" would resolve the corruption 
issue (I'm in writethrough mode), but the root was destroyed when 
corruption occurred in the middle of a nightly upgrade.
     4. When corruption isn't an issue (e.g. in a 3.10 kernel), I'm 
getting between a 50% and 80% cache hit ratio (again in writethrough, 
not writeback).  I'm pretty happy about that.  :)
     5. Creating a large number of small files seems to be quite a lot 
slower than it was without bcache.  (For instance, installing xfce4 and 
its dependencies into a fresh chroot takes about two hours.)  I've 
noticed that Debian packages in particular take longer; kernel header 
packages often take close to half an hour by themselves.  (Can anyone 
posit a reason for this?)

I'll be trying the 3.10.12 bcache-stable shortly, though I expect that 
it won't make a huge difference in the hibernation problem.  I just 
wanted to record this information in case someone else decides to give 
this a go.

Cheers,

Zach
