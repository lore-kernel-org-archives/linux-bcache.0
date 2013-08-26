From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: changes to make the udev rules work
Date: Tue, 27 Aug 2013 00:46:00 +0200
Message-ID: <521BDAA8.5090803@gmail.com>
References: <521B1E94.8090802@rolffokkens.nl> <kvfs5h$j12$1@ger.gmane.org> <521BC237.9000802@rolffokkens.nl> <521BC829.9080303@gmail.com> <521BD496.5060207@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521BD496.5060207-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> You're right, see below. That was an ugly one.
> 
> Do you think having blkid identify bcache itself would have helped, 
> or is there always a chance of contradictive signatures which may 
> confuse  blkid?

make-bcache should use libblkid to detect existing superblocks,
and bail and recommend wipefs.

Support in the other direction (having libblkid support bcache) is just a
nice-to-have, and will maybe allow simplifying a few things in bcache-progs.
The udev rule is written not to break if libblkid gets bcache support, but
it can't really be simplified, we still want to detect stray superblocks
even if the latest tools can't create them.
