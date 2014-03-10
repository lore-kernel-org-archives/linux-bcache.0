From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Slow writing of dirty data (bcache)
Date: Mon, 10 Mar 2014 20:56:20 +0000
Message-ID: <20140310205612.GA19912@sucs.org>
References: <531DE9A5.90801@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:55284 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbaCJU4W (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Mar 2014 16:56:22 -0400
Content-Disposition: inline
In-Reply-To: <531DE9A5.90801@nuclearwinter.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 10, 2014 at 11:34:45AM -0500, Larkin Lowrey wrote:
> 
> has 160+MB of dirty data. The dirty data is being written at a rate of 1
> page per second (8 sectors). At this rate it'll take 11 hrs to finish. I
> like to keep this array spun down when inactive but the drives can't
> spin down since they're being written to once a second.
> 
> This never happened when running 3.12.7. Is there anything I can do
> about this?

I believe this is intended behaviour - as the cache approaches the
writeback_percent level of fullness the rate of writeback will increase.
It is possible to override the writeback_rate by echoing a new value
into it but it will also change itself so you may find the rate falls
again...  Perhaps that can be avoided by echoing 0 into
writeback_percent too (see
http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev#n265)...

-- 
Sitsofe | http://sucs.org/~sits/
