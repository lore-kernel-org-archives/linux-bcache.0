From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache: Fix a writeback performance regression
Date: Thu, 22 Aug 2013 00:42:54 -0700
Message-ID: <20130822074253.GD14935@kmo-pixel>
References: <52114614.4070509@profihost.ag>
 <20130819222718.GA32104@kmo-pixel>
 <52132243.8050803@profihost.ag>
 <521323D1.1070503@profihost.ag>
 <20130821234715.GA4630@moria.home.lan>
 <5215A130.9080508@profihost.ag>
 <20130822054336.GA14935@kmo-pixel>
 <5215A8A8.90900@profihost.ag>
 <20130822060215.GB14935@kmo-pixel>
 <5215BEA4.6040101@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5215BEA4.6040101-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Aug 22, 2013 at 09:32:52AM +0200, Stefan Priebe - Profihost AG wrote:
> great!
> 
> Everything seems to work fine now! Except read_dirty always going to
> negative values after a reboot.

That one's fixed in 3.11 :)
