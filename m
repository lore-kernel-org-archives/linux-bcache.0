From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: register cache device hangs on bcache branch (3.6.0-rc3)
Date: Mon, 8 Oct 2012 18:15:31 +0000 (UTC)
Message-ID: <loom.20121008T201426-45@post.gmane.org>
References: <50731737.8090409@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Dave Jiang <dave.jiang@...> writes:

> 
> It looks like the bcache branch (3.6.0-rc3) hangs when registering a
> cache device. I don't have that issue with the 3.2 branch.
> 
> [root <at> test0 ~]# echo /dev/sdb1 >
> /sys/fs/bcache/register                       
> [  143.221306] bcache: invalidating existing data                              


I encountered the same problem and just switched to the 3.2 branch.

FYI.

-brad w.
