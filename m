From: luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
Subject: comparison with rival projects
Date: Thu, 16 Dec 2010 00:26:56 +0100 (GMT+01:00)
Message-ID: <1822941381.28401292455616547.JavaMail.root@shiva>
References: <503688497.28381292455530354.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503688497.28381292455530354.JavaMail.root@shiva>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: inf-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,
Iam new in problematic of caching persistent data. I want to use caching (on ssd disk) on my desktop with a lot of ram. I hope, it will provide me better latency for starting programs (developer/scientific desktop). My questions are:

Is it possible to use single ssd disk for making two caches? One for /dev/md2 (root partition, raid10) and second for /dev/md3 (raid5,home partition, etc) (I hope this is possible by partitioning that ssd disk and using partitions for caching)

Is it dangerous (in terms of data loss) to use writethrough caching to single ssd disk of raid5 block device? (I have 5 disks, using lvm on top of raid).

For caching device is most critical number for random reads or operations per second. Is it right?

Trim is not need feature for cache ssd device. It will have same cache performance without it. Is it right?

What benefits/disadvantages have bcache [1] project over dm-cache [2] and flashcache [3]? My current knowledge is that writethrough is possible only in bcache, but dm-cache is implemented in more "standard" way (thdough devicemaper). Also bcache has some more information on web.

[1] - http://bcache.evilpiepirate.org/
[2] - http://users.cis.fiu.edu/~zhaom/dmcache/index.html
[3] - https://github.com/facebook/flashcache

PS: Is there any tutorial for gentoo users?

Thanks for any explanations / answers,
--
LuVar
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
