From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] block: make sure big bio is splitted into at most 256
 bvecs
Date: Thu, 11 Aug 2016 07:02:53 -0700
Message-ID: <20160811140253.GA2867@infradead.org>
References: <1459914212-9330-1-git-send-email-ming.lei@canonical.com>
 <alpine.LRH.2.11.1608102132120.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbcHKOC4 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 11 Aug 2016 10:02:56 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1608102132120.10662@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, kent.overstreet@gmail.com, Christoph Hellwig <hch@infradead.org>, Sebastian Roesner <sroesner-kernelorg@roesner-online.de>, "4.3+" <stable@vger.kernel.org>, Shaohua Li <shli@fb.com>

Please just fix bcache to not submit bios larger than BIO_MAX_PAGES for
now, until we can support such callers in general and enable common
used code to do so.
