From: David Mohr <david@mcbf.net>
Subject: Re: caching device setup
Date: Mon, 06 Apr 2015 09:57:16 -0600
Message-ID: <498317a297a1038028f1393da9b49231@de.mcbf.net>
References: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from seeker.mcbf.net ([109.239.49.157]:34208 "EHLO seeker.mcbf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbbDFQcw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 6 Apr 2015 12:32:52 -0400
In-Reply-To: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org

On 2015-04-06 09:44, arnaud gaboury wrote:
> Here is my overall plan:
> 
> root filesystem & OS on a SSD
> DB and other stuff on HD.
> Use ssd as caching device and HD as backing.
> 
> Shall I partition the SSD with : one partition for OS and one empty
> for bcache? Or install the OS on the whole SSD and use the whole SSD
> as caching device?
> 
> Thank you for hint.

So this is just depending on your preference, how big the SSD is, and 
how much space you expect your OS to take up.

Personally I split my SSD into two partitions: one for the root FS, and 
the other as a caching device for /home.

~David
