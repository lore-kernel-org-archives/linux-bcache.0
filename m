From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 17 Jul 2015 16:17:01 -0700
Message-ID: <20150717231700.GA4166@kmo-pixel>
References: <20150714005825.GA24027@kmo-pixel>
 <1436940689.6520.1.camel@hasee>
 <CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
 <1436944556.6520.5.camel@hasee>
 <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34991 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbGQXRF (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jul 2015 19:17:05 -0400
Received: by pdrg1 with SMTP id g1so68440532pdr.2
        for <linux-bcache@vger.kernel.org>; Fri, 17 Jul 2015 16:17:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Wed, Jul 15, 2015 at 12:39:36AM -0700, Ming Lin wrote:
> On Wed, Jul 15, 2015 at 12:15 AM, Ming Lin <mlin@kernel.org> wrote:
> > On Tue, 2015-07-14 at 23:58 -0700, Kent Overstreet wrote:
> >> Can you strace it?
> >
> > Strange. Now error message changed.
> 
> I mean sometimes it showed:
> 
> mount: /dev/sdt already mounted or /mnt/ busy

I have no idea what's going on, it works for me - is there anything unusual
about your setup? what kind of block device is /dev/sdt? is there any chance
there's another process that has it open? maybe try rebooting?
