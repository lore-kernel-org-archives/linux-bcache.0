From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Mon, 26 Aug 2013 16:31:25 +0000 (UTC)
Message-ID: <kvfvst$j12$2@ger.gmane.org>
References: <521B1C5E.2090007@rolffokkens.nl>
	<20130826161758.GA4780@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, 26 Aug 2013 09:17:58 -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2013 at 11:14:06AM +0200, Rolf Fokkens wrote:
>> /sys/fs/bcache/register 2>/dev/null
>> 
>> I can imagine there's a more elegant solution, suggestions are welcome.
> 
> /sys/fs/bcache/register_quiet

Good point: the messages come from the kernel.

register_quiet would make legitimate errors harder to debug however.

I'll just send a patch to change "device already registered"
to a low-priority pr_debug message rather than something that
looks like an error.
