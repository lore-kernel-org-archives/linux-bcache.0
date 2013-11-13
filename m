From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: 3.10LTS ok for production?
Date: Tue, 12 Nov 2013 16:21:51 -0800
Message-ID: <08de01cee006$5b3aaa40$11affec0$@acm.org>
References: <20131109030128.GJ5474@bender.unx.csupomona.edu> <20131109064721.GC30271@kmo-pixel> <527DE027.2050606@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527DE027.2050606-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Stefan Priebe' <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: Stefan Priebe [mailto:s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org]
> Sent: Friday, November 08, 2013 11:12 PM
>
> 1.) dirty value is often wrong / can go negative
> 2.) writeback cache is only cleared / written back when having
> writeback_percent => 0

Hmm, neither of those result in data loss or corruption though?
