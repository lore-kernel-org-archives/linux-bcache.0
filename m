From: Ming Lin <mlin@kernel.org>
Subject: Re: bcachefs xattr
Date: Thu, 13 Aug 2015 00:49:13 -0700
Message-ID: <1439452153.21532.2.camel@hasee>
References: <1439451547.5775.9.camel@hasee>
	 <20150813074123.GA14629@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45077 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbHMHtQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Aug 2015 03:49:16 -0400
In-Reply-To: <20150813074123.GA14629@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, 2015-08-12 at 23:41 -0800, Kent Overstreet wrote:
> On Thu, Aug 13, 2015 at 12:39:07AM -0700, Ming Lin wrote:
> > Hi Kent,
> > 
> > Seems the max length of xattr name+value is only 2004 bytes.
> > Why the limit of U8_MAX below?
> 
> The size of the key and value is stored as a u8 in units of u64s - the u64s
> field of struct bkey.

xfstests/generic/020 failed.
Got it now.

xfs supports 64KB values.
In order to support larger size of value, does it make sense to store
the value in "extent"?
