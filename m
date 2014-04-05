From: Greg Michalec <greg@primate.net>
Subject: Restoring/Disabling bcache
Date: Sat, 05 Apr 2014 16:58:23 -0700
Message-ID: <5340989F.5040300@primate.net>
Reply-To: greg@primate.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56994 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaDEX6Z (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 5 Apr 2014 19:58:25 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so4954393pdi.33
        for <linux-bcache@vger.kernel.org>; Sat, 05 Apr 2014 16:58:25 -0700 (PDT)
Received: from [192.168.2.142] (c-50-156-34-49.hsd1.ca.comcast.net. [50.156.34.49])
        by mx.google.com with ESMTPSA id j3sm26848935pbh.38.2014.04.05.16.58.24
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 05 Apr 2014 16:58:24 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi -
Apologies in advance for asking a noob question, but I couldn't find
this information anywhere.

 0 down vote favorite
	

I have a 20 gb SSD device on my laptop that i decided to try bcache on.
I followed the instructions to convert my /home (ext4) to use bacache,
and it worked fine. It seemed to work, but for some time now, I've been
getting an error on boot:

error on 0f3bbb55-6839-4ed6-8127-7976a969f726: corrupted btree at bucket
17571, block 483, 61 keys, disabling caching

I figure I could try and repair this, but I've decided I'm probably
better off just disabling bcache - I don't know enough about this to
risk losing data/hair if something breaks, and I think I'd be better off
using the partition as root/swap.

My question is, is there a way to safely stop using bcache without
reformatting the backing device? Is it as simple as restoring the ext4
superblock and unregistering the device?  (Note, the filesystem on /home
seems to be fine - i think it's just disabling the caching)

I am using /dev/sda7 as my backing device, and /dev/sdb2 as the caching
device (/dev/sdb1 is root).

If it matters, I'm running Ubuntu 14.04 with kernel 3.13.0-21-generic.
Here's a link to this question on stackoverflow, if you'd like to answer
there for posterity - otherwise I'll post what ever info you respond with.
http://stackoverflow.com/questions/22820492/how-to-disable-bcache-on-device

Thank you!

--greg michalec
