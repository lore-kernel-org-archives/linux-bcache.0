From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Tue, 27 Aug 2013 14:11:00 +0200
Message-ID: <521C9754.5060305@gmail.com>
References: <521B1C5E.2090007@rolffokkens.nl> <20130826214155.GA2798@kmo-pixel> <521C4E2B.8090008@rolffokkens.nl> <521C78B8.7060402@grnet.gr> <kvi3hj$nvo$1@ger.gmane.org> <521C9560.2020603@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521C9560.2020603-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Gabriel, I might have been unclear about this, but this __IS__ a 
> problem on Fedora. Without a full path for modprobe (/sbin/modprobe 
> or /usr/sbin/modprobe) in bcache-register, udev does not create the 
> /dev/bcache* devices. So at the moment I fix it in the package.
> 
> If this is however Fedora specific I'll have the fix it in the 
> package of course. But it's hard for me to tell, and /sbin/modprobe 
> seemed like a cross-distro solution to me.

Oh, sorry.  Apparently it's not possible to pick the same path due to
Arch/Ubuntu differences, and it's not possible to use PATH due to Fedora.
I'm fine with your solution since we haven't hard from an Arch packager
(the AUR package is lagging way behind).
