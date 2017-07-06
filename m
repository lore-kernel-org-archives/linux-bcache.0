From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bcache: avoid a dangerous addressing in closure_queue
Date: Wed, 5 Jul 2017 20:36:28 -0700
Message-ID: <20170706033628.GA1007@infradead.org>
References: <1499259199-15161-1-git-send-email-liangchen.linux@gmail.com>
 <20170705193143.GA1050@infradead.org>
 <CAKhg4tLchH_+sR7VXq=hR7tHU_NRsrsxk6PVTfYx1-B5pA0W+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53130 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdGFDg3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jul 2017 23:36:29 -0400
Content-Disposition: inline
In-Reply-To: <CAKhg4tLchH_+sR7VXq=hR7tHU_NRsrsxk6PVTfYx1-B5pA0W+w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net

On Thu, Jul 06, 2017 at 08:18:02AM +0800, Liang Chen wrote:
> But as you pointed out, explicit casting is still bad too (was hoping it can be
> considered less bad at this situation). I will think of a better idea
> to handle this
> issue unless people agree that the current behaviour is safe.

Yes, let's find a way to avoids both the implicit and the explicit cast.
