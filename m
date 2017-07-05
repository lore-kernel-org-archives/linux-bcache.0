From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/19] bcache: fix calling ida_simple_remove() with
 incorrect minor
Date: Wed, 5 Jul 2017 11:26:45 -0700
Message-ID: <20170705182645.GD10673@infradead.org>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-5-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498855388-16990-5-git-send-email-bcache@lists.ewheeler.net>
Sender: stable-owner@vger.kernel.org
To: bcache@lists.ewheeler.net
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>
List-Id: linux-bcache@vger.kernel.org

> +#define BCACHE_TO_IDA_MINORS(first_minor) ((first_minor) >> BCACHE_MINORS_BITS)
> +#define IDA_TO_BCACHE_MINORS(minor)       ((minor) << BCACHE_MINORS_BITS)

Please use inline functions and lower case for these.
