From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools and bcache support in other linux packages
Date: Fri, 18 Oct 2013 15:30:51 +0200
Message-ID: <5261380B.2020007@gmail.com>
References: <CE86CB5C.BB96%rolf@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CE86CB5C.BB96%rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Development discussions related to Fedora <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> - Because it's hard to change an existing partition to a 'bcached'
> partition, it's not really tempting to test (there's a blocks utility
> under development that may help, currently backup-restore is the only way)

blocks[1] has been doing bcache conversion since forever (last march,
when the project was renamed from lvmify).

Backup-restore hasn't been necessary since then, apart from unusual
cases, like not having a /boot partition.

[1] https://github.com/g2p/blocks
