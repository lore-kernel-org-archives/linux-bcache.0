From: "Paul B. Henson" <henson@acm.org>
Subject: RE: md-raid5 with bcache member devices => kernel panic
Date: Thu, 5 Dec 2013 19:22:28 -0800
Message-ID: <057501cef232$66ced280$346c7780$@acm.org>
References: <20131205212913.GE1848@teapot> <20131205225234.GA4054@kmo> <20131205230813.GF1848@teapot> <20131205231547.GB4054@kmo>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51610 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab3LFDWe (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Dec 2013 22:22:34 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so234824pbc.24
        for <linux-bcache@vger.kernel.org>; Thu, 05 Dec 2013 19:22:34 -0800 (PST)
In-Reply-To: <20131205231547.GB4054@kmo>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: 'Kent Overstreet' <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

> From: Kent Overstreet
> Sent: Thursday, December 05, 2013 3:16 PM
>
> I'm reworking how all this crap works in mainline,
> maybe by 3.14 generic_make_request() will be accepting arbitrary size bios
> and the code that's probably buggy here will be gone.

Hmm, calling the current code crap is not exactly confidence inspiring for
running 3.11 or 3.12 in production ;).

If you're in an email answering mood, any chance I could trouble you to
answer the question I posed earlier this week about the -w option to
make-bcache, its relation (or not) to SSD page size,  and how to best
configure an SSD with a page size of 8k as a cache device :)?

Thanks.
