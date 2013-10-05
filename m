From: David Humphreys <dave-Ni3nFjXdSsm9FHfhHBbuYA@public.gmane.org>
Subject: Re: SDD Failure - What to do?
Date: Sat, 05 Oct 2013 15:37:13 +0100
Message-ID: <52502419.1030807@datatone.co.uk>
References: <524FC9DB.5080608@datatone.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524FC9DB.5080608-Ni3nFjXdSsm9FHfhHBbuYA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

OK, I have done the experimentation and everything is now clear and fixed.

The /sys/block/bcache0/bcache/state was 'none'.

So I did 'make-bcache -C /dev/sda8'

I did 'echo <UID> >/sys/block/bcache0/bcache/attach'

And I have /sys/block/bcache0/bcache/state is 'clean'.

So I'd say that this is what they would call 'cool'.

Complete SSD failure is easy to fix and did not cause any collateral damage.
