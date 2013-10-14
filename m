From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] unable to handle kernel NULL pointer dereference at 000000000000006c
 (bch_insert_data)
Date: Mon, 14 Oct 2013 14:38:12 +0200
Message-ID: <525BE5B4.6000003@gmail.com>
References: <1381699461.2306.6.camel@ThinkPad-X230.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381699461.2306.6.camel-aTCQVLFAsbFNyYP8qUDXA8/Rnsmy/zvw/z7RTEddyNg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Igor Gnatenko <i.gnatenko.brain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> On testday we found: https://bugzilla.redhat.com/show_bug.cgi?id=1018615
> which have dmesg after sysrq-t (also have some lines down).
> We setted cache_mode to writeback, mounted to foldear and started copy
> files to mounted bcache folder. It was copied some % and stayed.
> We running 3.11.4 kernel, which have fix for flushing data.
> 
> [ 1550.135293] BUG: unable to handle kernel NULL pointer dereference at 000000000000006c
> [ 1550.135335] IP: [<ffffffffa04cc659>] bch_insert_data+0x19/0x30 [bcache]

That's the bug mentioned here:
http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2113
http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2109
http://comments.gmane.org/gmane.linux.kernel.bcache.devel/2108

It's a regression that stops writeback and made 3.11.4.
The fix is in 3.12-rc5 and will be in 3.11.5.
