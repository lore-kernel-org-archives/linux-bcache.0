From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs xattr
Date: Wed, 12 Aug 2015 23:41:23 -0800
Message-ID: <20150813074123.GA14629@moria.home.lan>
References: <1439451547.5775.9.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35339 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbHMHl0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Aug 2015 03:41:26 -0400
Received: by pacgr6 with SMTP id gr6so32275407pac.2
        for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 00:41:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1439451547.5775.9.camel@hasee>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-bcache@vger.kernel.org

On Thu, Aug 13, 2015 at 12:39:07AM -0700, Ming Lin wrote:
> Hi Kent,
> 
> Seems the max length of xattr name+value is only 2004 bytes.
> Why the limit of U8_MAX below?

The size of the key and value is stored as a u8 in units of u64s - the u64s
field of struct bkey.

> 
> root@bee:~# dd if=/dev/zero bs=1 count=1996 2>/dev/null | attr -s "long_attr" /mnt/test/attr.txt
> attr_set: Numerical result out of range
> Could not set "long_attr" for /mnt/test/attr.txt
> 
> 183 int bch_xattr_set(struct inode *inode, const char *name,
> ...
> 
> 230                 if (value) {
> 231                         struct keylist keys;
> 232                         struct bkey_i_xattr *xattr;
> 233                         unsigned u64s = BKEY_U64s +
> 234                                 DIV_ROUND_UP(sizeof(struct bch_xattr) +
> 235                                              qname.len + size,
> 236                                              sizeof(u64));
> 237 
> 238                         if (u64s > U8_MAX) {
> 239                                 ret = -ERANGE;
> 240                                 break;
> 241                         }
> 
