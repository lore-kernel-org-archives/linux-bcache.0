From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: good bcache use case?
Date: Tue, 15 Oct 2013 08:00:03 -0700 (PDT)
Message-ID: <1381849203.67736.YahooMailNeo@web181503.mail.ne1.yahoo.com>
References: <1005c01cec92f$b61b2040$225160c0$@acm.org>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1005c01cec92f$b61b2040$225160c0$@acm.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> From my research so far, it seems that bcache in the 3.10 kernel is

> considered stable enough for production, and there shouldn't be any issues
> using software RAID for the backing and cache devices? Even with writeback
> enabled?


Anything shy of the official linux 3.11.5 kernel release has several time-bomb bugs. And apparently the project's GIT repo is an unreliable place to get the bug-fixed code because it's not being kept up to date. Until Kent et. al. remedies this procedural problem I would *only* use the 3.11.5 release and personally would be a bit circumspect in calling it fully production ready. I don't believe there are any known significant bugs but with the recent flurry of fixes I'd liken it's solidity as more pudding rather than cake.
