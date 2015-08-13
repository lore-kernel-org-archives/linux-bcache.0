From: Ming Lin <mlin@kernel.org>
Subject: bcachefs xattr
Date: Thu, 13 Aug 2015 00:39:07 -0700
Message-ID: <1439451547.5775.9.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44807 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbbHMHjK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Aug 2015 03:39:10 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Hi Kent,

Seems the max length of xattr name+value is only 2004 bytes.
Why the limit of U8_MAX below?

root@bee:~# dd if=/dev/zero bs=1 count=1996 2>/dev/null | attr -s "long_attr" /mnt/test/attr.txt
attr_set: Numerical result out of range
Could not set "long_attr" for /mnt/test/attr.txt

183 int bch_xattr_set(struct inode *inode, const char *name,
...

230                 if (value) {
231                         struct keylist keys;
232                         struct bkey_i_xattr *xattr;
233                         unsigned u64s = BKEY_U64s +
234                                 DIV_ROUND_UP(sizeof(struct bch_xattr) +
235                                              qname.len + size,
236                                              sizeof(u64));
237 
238                         if (u64s > U8_MAX) {
239                                 ret = -ERANGE;
240                                 break;
241                         }
