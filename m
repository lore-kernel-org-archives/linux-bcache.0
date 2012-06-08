From: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Subject: Working bcache =?UTF-8?Q?patchset=3F?=
Date: Fri, 08 Jun 2012 12:40:31 +0200
Message-ID: <18d9ec0eee7d5cee38ced035d38a7a23@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hey!

I'm currently evaluating bcache for a pet project of mine (seeing the 
great performance numbers in the hosting environment tests posted here 
really sold me on to the idea), but I'm currently stumped by the bcache 
HEAD repository state (bcache on a 3.4.0+) from 
http://evilpiepirate.org/cgi-bin/cgit.cgi/linux-bcache.git, which does 
compile fine (but only if you don't activate CGROUP support for bcache, 
that is broken, and the "simple" naming fixes for struct bcache_group I 
tested don't allow it to compile either...), but:

* the current head implements a (slightly) different kind of sysfs-API 
than is documented (concerning cache_mode, the "writeback" flag doesn't 
exist anymore), which is self-documenting mostly, at least from what I 
gather,
* and secondly, it's easy to lose a volume completely by simply setting 
a backing volume to writeback caching mode. Detaching the cache from a 
working writeback volume doesn't work at all (gives no dmesg output, 
does not seem to start the flush), stopping the backing volume does 
work, reattaching the cache device after registering the backing device 
again is impossible: "bcache: Couldn't find uuid for md127 in set",
* and thirdly, setting readahead to anything else than zero makes 
bcache access blocks behind the end of device (the backing device isn't 
a multiple of the readahead size I tested): "md127: rw=0, 
want=5816029416, limit=5816028912"

As people have had success with bcache from what I gather: is there any 
working revision/patch I can up/downgrade to? ;-) All other tags 
published on the mentioned gitweb don't seem to be versions which could 
be used pseudo-productively, and cloning from the published repository 
git://evilpiepirate.org/~kent/linux-bcache.git currently fails:

modelnine # git clone git://evilpiepirate.org/~kent/linux-bcache.git
Cloning into 'linux-bcache'...
remote: Counting objects: 2441832, done.
remote: aborting due to possible repository corruption on the remote 
side.
fatal: early EOF
fatal: index-pack failed
modelnine #

Scrolling through the repository state published by web didn't 
immediately hint at a previous tag/state in the repository that would be 
usable. Thanks for any hints!

-- 
--- Heiko.
