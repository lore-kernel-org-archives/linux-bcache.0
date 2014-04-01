From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Any way to allow contiguous writes to be cached?
Date: Tue, 1 Apr 2014 10:29:14 +0100
Message-ID: <20140401092856.GA12347@sucs.org>
References: <CAHnuAezVv20jS48FXUU7meithjgoKdBVRRZNgGJMZcGAGYv2KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:39211 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaDAJ3Q (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 1 Apr 2014 05:29:16 -0400
Content-Disposition: inline
In-Reply-To: <CAHnuAezVv20jS48FXUU7meithjgoKdBVRRZNgGJMZcGAGYv2KA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Daniel Smedegaard Buus <danielbuus@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi,

On Tue, Apr 01, 2014 at 09:10:23AM +0200, Daniel Smedegaard Buus wrote:
> 
> My actual data set isn't expected to grow beyond the size that the
> cache device offers any time soon, if ever, and so in my case, the
> optimum behavior of bcache would be to not just cache random data, but
> contiguous as well.
> 
> I realize that this isn't how bcache behaves, but I'm wondering if
> there's any way to tell it to do so?

A very frequent question - see TROUBLESHOOTING PERFORMANCE in the
bcache.txt document
(http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/bcache.txt#n130
) - explicitly the "Bad performance, or traffic not going to the SSD that
you'd expect".

-- 
Sitsofe | http://sucs.org/~sits/
