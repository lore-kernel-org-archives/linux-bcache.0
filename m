From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Bcache v. whatever
Date: Thu, 25 Apr 2013 16:17:04 -0700
Message-ID: <20130425161704.3f0fc3b6af55cf75acbc9d9e@linux-foundation.org>
References: <20130114223202.GV26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130114223202.GV26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, 14 Jan 2013 14:32:02 -0800 Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Bcache: a block layer SSD cache

sparc64 gcc-3.4.5:

drivers/md/bcache/btree.c: In function `bch_btree_read':
drivers/md/bcache/btree.c:266: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `__btree_write':
drivers/md/bcache/btree.c:379: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `btree_node_free':
drivers/md/bcache/btree.c:980: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `btree_insert_key':
drivers/md/bcache/btree.c:1857: error: invalid operands to binary +
drivers/md/bcache/btree.c:1857: error: invalid operands to binary +
drivers/md/bcache/btree.c:1859: error: invalid operands to binary +
drivers/md/bcache/btree.c:1859: error: invalid operands to binary +
drivers/md/bcache/btree.c:1864: error: invalid operands to binary +
drivers/md/bcache/btree.c:1864: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `btree_split':
drivers/md/bcache/btree.c:1934: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `bch_btree_set_root':
drivers/md/bcache/btree.c:2159: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `bch_btree_search_recurse':
drivers/md/bcache/btree.c:2262: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `bch_btree_refill_keybuf':
drivers/md/bcache/btree.c:2330: error: invalid operands to binary +

due to

#define pbtree(b)       (&bch_pbtree(b).s[0])

I don't know why this is happening (presumably a gcc glitch), but
returning an 80-byte struct by value from bch_pkey() and bch_pbtree()
is just gruesome.  The compiler has to allocate the space on the caller
stack, pass a hidden pointer into the callee and the callee copies its
return value into that caller stack slot.  It's slow and consumes stack.

Something different, please.
