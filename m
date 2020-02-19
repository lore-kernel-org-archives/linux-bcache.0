From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] bcache: move macro btree() and btree_root() into
 btree.h
Date: Wed, 19 Feb 2020 08:29:45 -0800
Message-ID: <20200219162945.GD10644@infradead.org>
References: <20200215082858.128025-1-colyli@suse.de>
 <20200215082858.128025-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200215082858.128025-2-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Sat, Feb 15, 2020 at 04:28:56PM +0800, Coly Li wrote:
> In order to accelerate bcache registration speed, the macro btree()
> and btree_root() will be referenced out of btree.c. This patch moves
> them from btree.c into btree.h with other relative function declaration
> in btree.h, for the following changes.

Can you give them a bcache_ prefix?  That names are awfully generic
and bound to clash sooner or later.
