From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: good bcache use case?
Date: Tue, 15 Oct 2013 12:12:43 -0700
Message-ID: <038e01cec9da$8a19e750$9e4db5f0$@acm.org>
References: <1005c01cec92f$b61b2040$225160c0$@acm.org> <1381849203.67736.YahooMailNeo@web181503.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381849203.67736.YahooMailNeo-XYahOdtEMNn35Xbc4wGBzZOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'matthew patton' <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: matthew patton [mailto:pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, October 15, 2013 8:00 AM
>
> Anything shy of the official linux 3.11.5 kernel release has several
time-bomb
> bugs.

Hmm, given 3.10 is an LTS kernel presumably these bug fixes would be back
ported? I suppose it would just be a matter of making sure for a given
3.10.x that they had been.

> personally would be a bit circumspect in calling it fully production
ready. I
> don't believe there are any known significant bugs but with the recent
flurry
> of fixes I'd liken it's solidity as more pudding rather than cake.

Well, that's not exactly a ringing endorsement :). I suppose I could always
stick with plan A and migrate to bcache later, it should be easy enough to
pvmove everything off of the SSD raid1, pvremove it, and then with a little
downtime convert the raid10 to a backing store and the SSD raid1 to a cache.

Thanks for the opinions.
