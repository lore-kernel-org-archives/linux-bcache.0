From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs xattr
Date: Wed, 12 Aug 2015 23:50:49 -0800
Message-ID: <20150813075049.GB14629@moria.home.lan>
References: <1439451547.5775.9.camel@hasee>
 <20150813074123.GA14629@moria.home.lan>
 <1439452153.21532.2.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34663 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbHMHux (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Aug 2015 03:50:53 -0400
Received: by pawu10 with SMTP id u10so32645203paw.1
        for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 00:50:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1439452153.21532.2.camel@hasee>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-bcache@vger.kernel.org

On Thu, Aug 13, 2015 at 12:49:13AM -0700, Ming Lin wrote:
> On Wed, 2015-08-12 at 23:41 -0800, Kent Overstreet wrote:
> > On Thu, Aug 13, 2015 at 12:39:07AM -0700, Ming Lin wrote:
> > > Hi Kent,
> > > 
> > > Seems the max length of xattr name+value is only 2004 bytes.
> > > Why the limit of U8_MAX below?
> > 
> > The size of the key and value is stored as a u8 in units of u64s - the u64s
> > field of struct bkey.
> 
> xfstests/generic/020 failed.
> Got it now.
> 
> xfs supports 64KB values.
> In order to support larger size of value, does it make sense to store
> the value in "extent"?

Perhaps, but let's leave that for now and add it if there's demand for it.
