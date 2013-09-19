From: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Subject: Re: [PATCH] bcache: Possible flush fix
Date: Thu, 19 Sep 2013 18:26:21 +0000 (UTC)
Message-ID: <loom.20130919T202224-113@post.gmane.org>
References: <loom.20130916T150548-751@post.gmane.org> <20130917020316.GC10907@kmo-pixel> <loom.20130917T122135-908@post.gmane.org> <20130917203741.GA32037@kmo-pixel> <loom.20130917T224603-574@post.gmane.org> <20130917214043.GF32037@kmo-pixel> <loom.20130918T134845-142@post.gmane.org> <20130918202809.GB19161@kmo-pixel> <loom.20130918T223347-893@post.gmane.org> <20130918204303.GC19161@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <kmo@...> writes:


> I just rebased bcache-3.10-stable and added the fix you tested to it.
> 
> Also, HEAD in the bcache repository now points to bcache-3.10-stable and
> not bcache-for-3.10.
> 
> Can you run echo t > /proc/sysrq-trigger when things get stuck, and give
> me the full dmesg output?
> 
Hi just before closing I did still following.
root@server:/# du -sh root
332K	root
cp -av /root /tmp/bcache/
sync

Until here everything is OK
Now I enter the following
root@server:/# du -sh etc
12M	etc

cp -av /etc /tmp/bcache/
sync 
And the sync command will not come back!
The dmesg I send by mail
