From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: bcache not working on large files?
Date: Tue, 22 Oct 2013 19:06:28 -0700
Message-ID: <0cde01cecf94$7dccdb50$796691f0$@acm.org>
References: <20131022070830.GA20286@euve30603.vserver.de> <5266B774.6040202@rolffokkens.nl> <20131022180316.GA24473@euve30603.vserver.de> <1382476284.36900.YahooMailNeo@web181506.mail.ne1.yahoo.com> <20131022214553.GC26186@euve30603.vserver.de> <1382480829.46079.YahooMailNeo@web181504.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382480829.46079.YahooMailNeo-XYahOdtEMNkbWpotXP+qY5OW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'matthew patton' <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, 'Dirk Geschke' <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: matthew patton
> Sent: Tuesday, October 22, 2013 3:27 PM
>
> 'busted' in this case means errors on write. If the device disappears and
is no
> longer readable, then sure any un-committed blocks are gone and your
> filesystem/file is broken.

In other words, if you care about your data, don't use a nonredundant cache
device in writeback mode 8-/. I'm tentatively planning to use an md mirror
of two 256G SSD's to front end a raid10 of 4 2TB HD's, I'm still in the
investigate stage but hopefully will get to prototyping soon.
 
> If you're not running kernel 3.11.5 (or 3.11.4 with *all* the bcache
fixes)
> you're wasting your time.

Is there an intention to port all of these fixes back to an LTS 3.10 kernel,
or if you're going to run in production you're pretty much committed to the
latest stable?

Thanks.
