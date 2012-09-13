From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache crash/bugs on HEAD (rebased on 3.6-rc5)
Date: Thu, 13 Sep 2012 18:21:43 +1000
Message-ID: <CAOzFzEhb85zzrREM8wwg--6sNyGLVHD88wCkX+NVUkBSnjjg+Q@mail.gmail.com>
References: <CAOzFzEhfGi0Z6r0q_3D6M181yC0t5GTs0VG6Y-9LCqU_gJCt+g@mail.gmail.com>
	<CAOzFzEi=esX5SD9Fhy2utsR=bq5R9jxPKKez7CfwmwtOTHvNGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEi=esX5SD9Fhy2utsR=bq5R9jxPKKez7CfwmwtOTHvNGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I am able to consistently cause it to hang with the second trace (the
rcu_check_callbacks one) with the following fio jobfile.

[global]
numjobs=16
iodepth=64

[/dev/dsan/bcache]
bs=4k
ba=4k
rw=randwrite
size=1g
direct=1
ioengine=libaio

Another interesting note is that while in this state cat'ing stats
files like root_usage_percent cause the entire system to hang
completely.
I imagine this is due to some sort of sync.

Joseph.
