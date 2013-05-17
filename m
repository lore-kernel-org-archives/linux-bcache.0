From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Poor performance with bcache write-back mode
Date: Fri, 17 May 2013 20:50:08 +0000 (UTC)
Message-ID: <kn6560$o7q$1@ger.gmane.org>
References: <1368741106.62060.YahooMailNeo@web162401.mail.bf1.yahoo.com>
	<CA+gjuN7E2B+71BiCexm7HjDGzJMBuCdbGxhvD8YHU6-u6TyKkg@mail.gmail.com>
	<1368821584.52750.YahooMailNeo@web162405.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, 17 May 2013 13:13:04 -0700, Patrick Ng wrote:
> Hi Robert,
> 
> I have checked that the cache partition (/dev/sdc1) starts at 2048, it should be properly aligned.
> Similarly for the backing store partition (/dev/sdb1), it starts at 2048 at well.

The bcache superblock shifts the start of your partition by 8k though.
I don't know if the upper layers compensate for that, but just in case,
you may want to add `--data_offset 2048` to the make-bcache command line
(1M alignment).
