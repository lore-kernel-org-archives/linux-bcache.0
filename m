From: Vivek Dasmohapatra <vivek@collabora.co.uk>
Subject: Re: bcache questions
Date: Sun, 9 Mar 2014 01:50:53 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1403090146430.17442@noise.cbg.collabora.co.uk>
References: <20140306093341.GA31900@sucs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52912 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaCIBu5 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 8 Mar 2014 20:50:57 -0500
In-Reply-To: <20140306093341.GA31900@sucs.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-bcache@vger.kernel.org

> Finally, is it possible to limit the amount of cache a particular
> backing device can use?

I'm not sure if it is, but you might be able to get the same end result
by using partitions on the cache device to make separate sets: That is,
instead of:

   { cache: backing }
   { sdb  : sda1 }
   { sdb  : sda3 }

You could try

   { sdb1 : sda1 }
   { sdb2 : sda3 }

and so forth, partitioning sdb appropriately.
[ Disclaimer: I have not actually tried this ]
