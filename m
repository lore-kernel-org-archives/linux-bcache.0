From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Correct way to remove a cache device?
Date: Mon, 31 Mar 2014 13:06:24 +0100
Message-ID: <20140331120623.GA28637@sucs.org>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:36334 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaCaMGZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Mar 2014 08:06:25 -0400
Content-Disposition: inline
In-Reply-To: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Daniel Smedegaard Buus <danielbuus@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 31, 2014 at 01:47:21PM +0200, Daniel Smedegaard Buus wrote:
> 
> I'm trying to figure out what the correct way of taking down a bcache
> cache device is.
> 
> If I echo 1 to /sys/block/BACKING_DEVICE/bcache/detach, and then to
> /sys/fs/bcache/*/unregister, the system will hang. The detach part
> goes well, but immediately after unregistering, it will crash.

Try sleeping at least two seconds between the operations.

-- 
Sitsofe | http://sucs.org/~sits/
