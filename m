From: Giovanni Lenzi <giovanni.lenzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: is the fail-over of two bcached volumes in raid 1 really possible?
Date: Tue, 5 Feb 2013 17:24:47 +0100
Message-ID: <CAAxY4JmnH4sam7JfAt0UTgjEBN-aYnwutPhpaTVX_FbC_2Anpw@mail.gmail.com>
References: <CAAxY4JkfGwg-+BGu6nYoSWBW64VS6ZyLaHNrzW493Davwx_Bvg@mail.gmail.com>
	<CAAxY4JkKVvk0i-6W2-QC=qsfB8iKtvp6PLs-PMkdRcRW5LEuTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAxY4JkKVvk0i-6W2-QC=qsfB8iKtvp6PLs-PMkdRcRW5LEuTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'm going to put bcache in write-back mode ..


---------- Forwarded message ----------
From: Giovanni Lenzi <giovanni.lenzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: 5 February 2013 09:57
Subject: Fwd: is the fail-over of two bcached volumes in raid 1 really possible?
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi all,
I'm planning to use bcache in a production environment.

For failover purposes, I would like to have two cached hard disk in
raid 1 via md or dm.

ssd1 caching physical hd1(1 or 2 tb)
and
ssd2 caching physical hd2(1 or 2 tb)

Is it possible to raid over bcached volumes?

Do you know if SSD or HD failures are correctly handled by software
layers above the physical volumes and does not cause disruptive
behaviour even in a raid 1 situation?

Is there a way to know if one bcache volume in the raid is failing or
failed, through something like kernel, bcache or raid logs?

I want to put some monitoring tool like nagios on my machine, in order
to be notified of all strange events on my volumes.

Do you think raid1 will affect performance?

I will try this configuration as soon as my ssd will arrive.

In case I begin with 1 tb hard disks and would like to switch to 2tb
hard disks in the future, I would like to know if is it possible to
extend these mirrored cached volumes on the fly and WITHOUT DOWN
TIMES?

Thanks in advance
--
Giovanni
