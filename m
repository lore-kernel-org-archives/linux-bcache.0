From: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Subject: Re: [PATCH] bcache: Possible flush fix
Date: Thu, 19 Sep 2013 08:52:58 +0000 (UTC)
Message-ID: <loom.20130919T104737-494@post.gmane.org>
References: <loom.20130916T150548-751@post.gmane.org> <20130917020316.GC10907@kmo-pixel> <loom.20130917T122135-908@post.gmane.org> <20130917203741.GA32037@kmo-pixel> <loom.20130917T224603-574@post.gmane.org> <20130917214043.GF32037@kmo-pixel> <loom.20130918T134845-142@post.gmane.org> <20130918202809.GB19161@kmo-pixel> <loom.20130918T223347-893@post.gmane.org> <20130918204303.GC19161@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <kmo@...> writes:


> 
> I just rebased bcache-3.10-stable and added the fix you tested to it.
> 
> Also, HEAD in the bcache repository now points to bcache-3.10-stable and
> not bcache-for-3.10.
> 
> Can you run echo t > /proc/sysrq-trigger when things get stuck, and give
> me the full dmesg output?
> 

I have now tested with the latest git kernel.
It has become better again, but the basic problem remains.
The dmesg messages I send via e-mail


root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 09:26:43 CEST 2013
/dev/bcache0                                             74G    1,7G   68G 
  3% /tmp/bcache
root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 09:28:09 CEST 2013
/dev/bcache0                                             74G    4,6G   65G 
  7% /tmp/bcache
root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 09:51:41 CEST 2013
/dev/bcache0                                             74G     11G   59G 
 16% /tmp/bcache
root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 09:56:05 CEST 2013
/dev/bcache0                                             74G     12G   59G 
 17% /tmp/bcache
root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 10:00:42 CEST 2013
/dev/bcache0                                             74G     12G   58G 
 17% /tmp/bcache
root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 10:03:58 CEST 2013
/dev/bcache0                                             74G     12G   58G 
 17% /tmp/bcache
root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 10:14:56 CEST 2013
/dev/bcache0                                             74G     13G   58G 
 18% /tmp/bcache
root@server:/usr/src# date;df -h | grep bcache
Do 19. Sep 10:39:14 CEST 2013
/dev/bcache0                                             74G     13G   57G 
 19% /tmp/bcache
root@server:/usr/src# du -sh
14G	.
root@server:/usr/src# 
