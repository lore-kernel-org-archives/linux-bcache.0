From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: bcache: Fix a writeback performance regression
Date: Thu, 22 Aug 2013 09:32:52 +0200
Message-ID: <5215BEA4.6040101@profihost.ag>
References: <520C788A.1060208@profihost.ag> <520DFAB4.1050402@profihost.ag> <52114614.4070509@profihost.ag> <20130819222718.GA32104@kmo-pixel> <52132243.8050803@profihost.ag> <521323D1.1070503@profihost.ag> <20130821234715.GA4630@moria.home.lan> <5215A130.9080508@profihost.ag> <20130822054336.GA14935@kmo-pixel> <5215A8A8.90900@profihost.ag> <20130822060215.GB14935@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130822060215.GB14935@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

great!

Everything seems to work fine now! Except read_dirty always going to
negative values after a reboot.

Stefan

Am 22.08.2013 08:02, schrieb Kent Overstreet:
> On Thu, Aug 22, 2013 at 07:59:04AM +0200, Stefan Priebe wrote:
>>
>>> schedule_timeout() is not the same as
>>> schedule_timeout_interruptible().
>>
>> just search and replace? So i can try on my own.
> 
> The one in read_dirty(), line ~330
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
