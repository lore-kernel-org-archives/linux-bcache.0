From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Negative stats value
Date: Thu, 11 Jul 2013 18:28:41 -0700
Message-ID: <20130712012841.GC17799@kmo-pixel>
References: <103FE78F-7B2E-4B2F-83E6-51D2DEE33BB3@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <103FE78F-7B2E-4B2F-83E6-51D2DEE33BB3-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 11, 2013 at 07:32:05AM +0200, Stefan Priebe - Profihost AG wrote:
> I've seen negative dirty cache values several times. Is there a fix available?

Yeah, this should be fixed in the bcache-for-3.11 branch - but it's
harmless in the meantime.
