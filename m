From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: How to invalidate all cache
Date: Mon, 13 Oct 2014 10:43:14 +0700
Message-ID: <178936476.20141013104314@pvgoran.name>
References: <20141013030351.GA12742@gmail.com> <CACHGV4Jn3ML=2PO9FtoT4OXZCtpt56bOb=TmnVanv7Tm2MJyDg@mail.gmail.com> <20141013034536.GA13155@gmail.com>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:54861 "EHLO
	v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaJMDo3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 12 Oct 2014 23:44:29 -0400
In-Reply-To: <20141013034536.GA13155@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello Zheng,

Monday, October 13, 2014, 10:45:37 AM, you wrote:

> Yes, detaching a backing device will make all dirty data to be written
> back to the backing device.  But if I understand correctly it couldn't
> invalidate all data in cache device.  That means that after attaching
> backing device the data in cache device is still valid.

It  would  be  a  bug if cached data were considered valid after detaching and
re-attaching. Because while a cache device an a backing device were separated,
data  could be written to a backing device, this would possibly make data in a
"disconnected" cache obsolete.

Pavel Goran
  
